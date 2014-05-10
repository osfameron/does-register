<!-- Angular controllers -->

var app = angular.module('DoES-Register', []);

app.factory('socket', function ($rootScope) {

    var socket = io.connect( );
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
            console.log(args);
            console.log(args[numArgs-1]);
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

    $scope.showAddMember = false;
    $scope.toggleAddMember = function () {
        $scope.showAddMember = ! $scope.showAddMember;
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
    });

    socket.emit('hello'); // Tell server we are ready for first visits list
}); 

// from http://stackoverflow.com/questions/14833326/how-to-set-focus-in-angularjs
app.directive('focusMe', function($timeout, socket) {
    return {
        scope: true,
        link: function(scope, element, attrs) {
            scope.$watch(attrs.focusMe, function(value) {
                if(value) { 
                    $timeout(function() {
                        element.val('');
                        element.focus();
                        console.log(socket);
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

    /*

    function member_search_create (socket, position, callback) {
    };

    socket.emit('member_visit', item.id);

    */
