var driver= function(){
	
	$("#search_bar").keypress(function(e){

		if(e.keyCode==13){
			send_search()
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
function error(error_message){
	$("#error").text(error_message);
}
function send_search(){
	
	var group_id = $("input[name=group_selected]:checked").val();
	var search_term = $("#search_bar").val();
	if(search_term === ""){
		error("Please enter a search term")
	}else if(group_id == null){
		error("Please select a group to search")
	}else{
		alert("search sent")
		search(group_id, search_term)
		
	}
	
}
function search(grp_id, s_term){
	var search_host = "http://localhost:4567";
	$.post(search_host+"/search", {group_id: grp_id, search_term: s_term}, function (data){
		alert(data.test)
	})
}
$(document).ready(function () {
	driver()
});