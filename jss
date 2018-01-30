$(document).on("ajax:success",".booking_slot", function (data,response,event) {
	console.log(data);
	console.log(event);	
	console.log(response);

	$(".slot_item").remove();
	response.status.map(item => 
		$(".slot_list").append($("<div class=slot_item ><input type=radio value="+item+":00:00 name=appointment[start_time]>"+ 
			item+":00 PM"
			+"<br></div")));
});


