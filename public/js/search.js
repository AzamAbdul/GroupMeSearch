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
	var tok = $("#token").val();
	if(search_term === ""){
		error("Please enter a search term")
	}else if(group_id == null){
		error("Please select a group to search")
	}else{
		
		search(group_id, search_term, tok)
		
	}
	
}
function addMessageToPage(message){
	var message_div = document.createElement("div")
	message_div.classList.add("row")
	message_div.classList.add("message")

	var pro_pic_div = document.createElement("div")
	pro_pic_div.classList.add("col-md-1")

	var pro_pic_img = document.createElement("img")
	pro_pic_img.classList.add("img-circle")
	pro_pic_img.classList.add("pro_pic")
	pro_pic_img.src=message.avatar
	pro_pic_img.width = 75
	pro_pic_img.height= 75

	pro_pic_div.appendChild(pro_pic_img)
	message_div.appendChild(pro_pic_div)
	
	var message_body_div = document.createElement("div")
	message_body_div.classList.add("col-md-11")
	message_body_div.classList.add("message_body")

	var username_div = document.createElement("div")
	username_div.classList.add("row")
	username_div.classList.add("user_name")
	username_div.classList.add("col-md-3")
	username_div.innerHTML = message.name
	message_body_div.appendChild(username_div)
	

	var message_text_div = document.createElement("div")
	message_text_div.classList.add("row")
	message_text_div.classList.add("col-md-12")
	message_text_div.classList.add("message_text")
	message_text_div.innerHTML = message.text
	message_body_div.appendChild(message_text_div)

	message_div.appendChild(message_body_div)
	document.getElementsByClassName("results")[0].appendChild(message_div)

}
function search(grp_id, s_term,tok){
	var search_host = "http://localhost:4567";
	$.post(search_host+"/search", {group_id: grp_id, search_term: s_term,token: tok }, function (data){
		$('#results_form').empty()
		data.forEach( function (message)
		{
			addMessageToPage(message)
			var x = message.text
			
		});
		 $("body").css({"overflow":"visible"});

		 $(".results").show()
		 window.location.hash = '#results_form';
	})
}
$(document).ready(function () {
	driver()
});