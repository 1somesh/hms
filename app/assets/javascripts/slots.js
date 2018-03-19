$(document).on('change',"#appointment_doctor_id",function () {
	hide_slot_item();
});

function hide_slot_item(){
	if($(".slot_item").length !=0)
		$(".slot_item").hide();
}

$(document).on('change','.remove_slot_list',function () {
	hide_slot_item();
});

$(document).on('change','#user_image',function(){
	$(".profile_image_upload").html("<input type = 'submit' value='Change Picture'>");
});
