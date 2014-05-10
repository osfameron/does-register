<!-- Angular controllers -->

var app = angular.module('DoES-Register', []);

app.factory('socket', function ($rootScope) {

    console.log("FACTORY");
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
        emit: function(eventName, data, callback) {
            socket.emit(eventName, data, function() {
                var args = arguments;
                $rootScope.$apply(function() {
                    if(callback) {
                        callback.apply(socket, args);
                    }
                });
            });
        }
    };
});

app.controller('VisitCtrl', function ($scope, socket) {
    $scope.visits = [];

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



    /*

    function member_search_create (socket, position, callback) {
        socket.emit('get_members', function (members) {
            $.each(members, function (i,m) {
                m.label = m.name;
            });
            div = $('<div class="member_widget">');
            input = $('<input type="text" name="member_name">');
            create = $('<button name="create_new"> Create </button>')
                .click(function () { alert("TODO") });
            cancel = $('<button name="create_new"> Cancel </button>')
                .click(function () { div.remove() });
            div.append(input, create, cancel);
            input.autocomplete({ 
                source: members,
                select: function (event, ui) {
                    callback(socket, ui.item);
                    div.remove();
                }
            });
            div.insertAfter(position);
            input.focus();
        });
    };

    $('#add_member .plus').unbind('click').click( function () {
        if ( $('#add_member input').length ) {
            $('#add_member input').focus();
            return;
        }
        member_search_create(socket, $(this), function (socket, item) {
            socket.emit('member_visit', item.id);
        });
    });
    */
