function deleteSelectedItems(table, deleteUrl, confirmation, errorMessage) {
	id = $(table).getGridParam('selarrrow');
	if (errorMessage && id == '') {
		alert(errorMessage);
		return;
	}
	if (confirm(confirmation)) {
		$.ajax({
			url: deleteUrl,
			type: 'POST',
			data: {'id[]': id},
			dataType: 'json',
			success : function(data, textStatus) {
				clearMessages();
				showSuccess(data.message);
				$(table).trigger("reloadGrid");
			},
			error : function(data, textStatus) {
				clearMessages();
				showError(data.message);
			}
		});
	}
}

function clearMessages() {
	$('#messages').empty();
}

function showSuccess(message) {
	$.create('div', {className: "ui-widget"}, [
		$.create('div', {className: "ui-state-highlight ui-corner-all ui-message"}, [
			$.create('p', {}, [
				$.create('span', {className: "ui-icon ui-icon-info"}, []),
				message
			])
		])
	]).appendTo('#messages');
}

function showError(message) {
	$.create('div', {className: "ui-widget"}, [
		$.create('div', {className: "ui-state-error ui-corner-all ui-message"}, [
			$.create('p', {}, [
				$.create('span', {className: "ui-icon ui-icon-alert"}, []),
				message
			])
		])
	]).appendTo('#messages');
}

function addGridButton(grid, placeHolder, options) {
    if (!window.isAddGridButtonExecuted) {
        isAddGridButtonExecuted = true;
        $(grid).navButtonAdd(placeHolder, options);
    }
}

function addGridRowButtons(grid, viewButton, editButton) {
    var ids = $(grid).jqGrid('getDataIDs');

    for (var i=0;i < ids.length;i++) {
        var cl = ids[i];
        detailsLink = '<a title="' + viewButton.title + '" href="' + viewButton.path.replace(/:id/, cl) + '"><span class="ui-icon ' + viewButton.icon + '"></span></a>';
        editLink = '<a title="' + editButton.title + '" href="' + editButton.path.replace(/:id/, cl) + '"><span class="ui-icon ' + editButton.icon + '"></span></a>';
        $(grid).jqGrid('setRowData',ids[i],{action_view:detailsLink});
        $(grid).jqGrid('setRowData',ids[i],{action_edit:editLink});
    }
}

function fixGridHeight(grid, maxHeight) {
    var gridHeight = $(grid).height();
    if (gridHeight > maxHeight) {
        gridHeight = maxHeight;
    }

    if ($.browser.msie) {
        gridHeight += 1;
    }
    $('.ui-jqgrid-bdiv').height(gridHeight);
}

