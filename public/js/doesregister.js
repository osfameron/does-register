<!-- Angular controllers -->

function VisitCtrl($scope) {
    $scope.visits = [];

    $scope.end_visit = function (visit) {
        console.log(visit, visit.visit_id);
        $scope.socket.emit('end_visit', visit.visit_id);
    }
}

$(function () {

    <!-- PocketIO -->
    var socket = io.connect( );
    var $visit = $('table#visits').scope();
    $visit.$apply( function () { $visit.socket = socket });

    socket.on('connect', function () {
        console.log('CONNECTED');
    });
 
    socket.on('visits', function (visits) {
        $visit.$apply( function () { $visit.visits = visits });
    });

    socket.emit('hello'); // Tell server we are ready for first visits list

    <!-- JQuery -->

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

});
