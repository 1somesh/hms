$(document).on("ajax:success",".booking_slot", function (data,response,event) {
	console.log(data);
	console.log(event);	
	console.log(response);

	if(response.status=="success"){
			if(response.slots.length!=0){
				$(".slot_item").remove();
				response.slots.map(item => 
				$(".slot_list").append($("<div class=slot_item ><input type=radio value="+item+":00:00 name=appointment[start_time]>"+ 
					item+":00 PM"
					+"<br></div>")));
			document.getElementById("appointment_date").value = response.date;
			document.getElementById("doctor_id").value = response.doctor_id;
			}
			else{
				$(".slot_item").remove();
				alert("no slots avilable for today");
			}
	}
	else{
		alert("please select a future date");
	}

});

