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
})

$('.close-btn-x').click(function(){
	$('.layer-bg').hide();
	$('.layer').hide();
})

$('.layer-bg').click(function(){
	$('.layer-bg').hide();
	$('.layer').hide();
})