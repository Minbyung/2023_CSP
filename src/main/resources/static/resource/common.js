$('select[data-value]').each(function(index, item){
	
	const items = $(item);
	
	const defaultValue = items.attr('data-value').trim();
	
	if (defaultValue.length > 0) {
		items.val(defaultValue);
	}
	
})

$('.popUp-exam').click(function(){
	let popOption = 'width=500px, height=500px, top=200px, scrollbars=yes';
	let openUrl = '/usr/home/popUp';
	window.open(openUrl, 'pop', popOption);
})

$('.modal-exam').click(function(){
	$('.layer-bg').show();
	$('.layer').show();
})

$('.close-btn').click(function(){
	$('.layer-bg').hide();
	$('.layer').hide();
	$('.invite-layer').hide();
	$(".invite-email-input").val('');
})

$('.close-btn-x').click(function(){
	$('.layer-bg').hide();
	$('.layer').hide();
	$('.invite-layer').hide();
	$(".invite-email-input").val('');
})

$('.layer-bg').click(function(){
	$('.layer-bg').hide();
	$('.layer').hide();
	$('.invite-layer').hide();
	$(".invite-email-input").val('');
})


//초대메일전송 모달
$('.invite-modal').click(function(){
	$('.layer-bg').show();
	$('.invite-layer').show();
})
