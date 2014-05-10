<!-- Angular controllers -->

var app = angular.module('DoES-Register', ['ui.bootstrap']);

app.factory('socket', function ($rootScope) {

    var socket = io.connect( );
    // wrap on/emit so that the supplied callbacks are run in the correct scope
    return {
        on: function(eventName, callback) {
            socket.on(eventName, function() {
                var args = arguments;
                $rootScope.$apply(function() {
                    callback.apply(socket, args);
                });
            });
        },
        emit: function() {
            var args = Array.prototype.slice.call(arguments);
            var numArgs = args.length;

            var callback;
            if (typeof(args[numArgs-1]) === 'function') {
                callback = args.pop();
            }

            callback_wrapper = function () {
                var args = arguments;
                $rootScope.$apply(function() {
                    if(callback) {
                        callback.apply(socket, args);
                    }
                });
            };

            args.push(callback_wrapper);

            socket.emit.apply(socket, args);
        }
    };
});

app.controller('VisitCtrl', function ($scope, socket) {
    $scope.visits = [];

    // functionality for the + button
    $scope.selectedMember = '';
    $scope.showAddMember = false;
    $scope.toggleAddMember = function () {
        $scope.showAddMember = ! $scope.showAddMember;
    }
    $scope.showName = function ($model) {
        if (!$model) return;
        return $model.name;
    }
    $scope.selectMember = function ($model) {
        console.log($model);
        console.log(socket);
        socket.emit('member_visit', $model.id);
    }

    $scope.end_visit = function (visit) {
        console.log(visit, visit.visit_id);
        socket.emit('end_visit', visit.visit_id);
    }

    socket.on('connect', function () {
        console.log('CONNECTED');
    });
 
    socket.on('visits', function (visits) {
        $scope.visits = visits;
        $scope.showAddMember = false;
    });

    socket.emit('hello'); // Tell server we are ready for first visits list
}); 

// expanded from http://stackoverflow.com/questions/14833326/how-to-set-focus-in-angularjs
// ideally, this should also init the typeahead stuffs
app.directive('initMembers', function($timeout, socket) {
    return {
        scope: true,
        link: function(scope, element, attrs) {
            scope.$watch(attrs.initMembers, function(value) {
                if(value) { 
                    $timeout(function() {
                        element.val('');
                        element.focus();
                        socket.emit('get_members', function (members) {
                            $.each(members, function (i,m) {
                                m.label = m.name;
                            });
                            console.log(members);
                            scope.members = members;
                       });
                    });
                }
            });
        }
    };
});
