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
	$('#ui-messages').empty();
}

function showSuccess(message) {
	$.create('div', {className: "ui-widget"}, [
		$.create('div', {className: "ui-state-highlight ui-corner-all ui-message"}, [
			$.create('p', {}, [
				$.create('span', {className: "ui-icon ui-icon-info"}, []),
				message
			])
		])
	]).appendTo('#ui-messages');
}

function showError(message) {
	$.create('div', {className: "ui-widget"}, [
		$.create('div', {className: "ui-state-error ui-corner-all ui-message"}, [
			$.create('p', {}, [
				$.create('span', {className: "ui-icon ui-icon-alert"}, []),
				message
			])
		])
	]).appendTo('#ui-messages');
}

function addGridButton(grid, placeHolder, buttons) {
    if (!window.isAddGridButtonExecuted) {
        isAddGridButtonExecuted = true;
        for (var b in buttons) {
            button = buttons[b]
            button.onClickButton = eval("(" + button.onClickButton + ")")
            $(grid).navButtonAdd(placeHolder, buttons[b]);
        }
    }
}

function addGridRowButtons(grid, buttons) {
    var ids = $(grid).jqGrid('getDataIDs');

    for (var i=0;i < ids.length;i++) {
        var cl = ids[i];
        for (var b in buttons) {
            button = buttons[b]
            link = '<a title="' + button.title + '" href="' + button.path.replace(/:id/, cl) + '"><span class="ui-icon ' + button.icon + '"></span></a>';
            options = {};
            options[button.column] = link;
            $(grid).jqGrid('setRowData',ids[i],options);
        }
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

function gridErrorHandler(r, data) {
  result = eval('(' + r.responseText + ')')
  if (result) {
    if (result.success) {
        showSuccess(result.message);
    }
    else {
        showError(result.message);
    }
  }
  return [true, ''];
}

