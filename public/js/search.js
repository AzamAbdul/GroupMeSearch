var driver= function(){
	
	$("#search_bar").keypress(function(e){

		if(e.keyCode==13){
			alert("pressed enter")
		}

	})

}
function test(group_element, group_radio_id){
	var elems = document.querySelectorAll(".group");

	[].forEach.call(elems, function(el) {
		el.classList.remove("group_select");
	});
	$(group_element).addClass("group_select")
	var radio_button = $("#"+group_radio_id)
	
	radio_button.prop("checked", true)
}
$(document).ready(function () {
	driver()
});