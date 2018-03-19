jQuery(function() {
  $("a.fancybox").fancybox();
});


$(document).on('change','.appointment_dates',function () {
 	get_appointment_slot();
});


function get_appointment_slot(data,event){
	year = $("#appointment_date_1i").val();
	month = $("#appointment_date_2i").val();
	day = $("#appointment_date_3i").val();
	date = year+"-"+month+"-"+day;
	$.ajax({
		url: "/appointments/slots",
		type: "post",
		data: {
			date: date,
			doctor_id: $("#appointment_doctor_id").val()
		},
		success: function(response){
				if(response.status=="success"){
						if(response.slots.length!=0){

							$(".slot_item").html(create_list(response));
							$('.slot_item').show();
						}
						else{
							
							alert("no slots avilable for today");
						}
				}
				else{
				    hide_slot_item();
					alert("please select a future date");
				}
		},
		error: function(response){
			alert(response);
		}
	}
);}



$(document).on("ajax:success",'.container',function(){
		$(this).remove();
});


function create_list(response){
	list = response.slots.map(slot => "<div class=slot_item ><input type=radio value="+slot+":00:00 name=appointment[start_time]> "+ 
								slot+":00 AM"
								+"<br></div><br>");
	return list;
}


$(document).on('change',"#user_role",function(){
	if($("#user_role").val()=="doctor"){
		$("#doctor_duration").show();
	}
	else{
		if($("#doctor_duration").length !=0)
			$("#doctor_duration").hide();
	}
});

$(document).ready(function(){
		if($("#user_role").val()=="patient" && $("#doctor_duration").length !=0)
			$("#doctor_duration").hide();
		
});


