function init_form(){
	update_fields();
	var t = document.getElementsByName("type");
	t[0].onchange = function() {
		update_fields();
	}	
}

function update_fields(){
	var type = document.getElementsByName("type");
	var ip_li = document.getElementById("ip_li");
	var folder_li = document.getElementById("folder_li");
	var user_li = document.getElementById("user_li");
	var passw_li = document.getElementById("passw_li");

	if (type[0].value=='NFS'){
		ip_li.style.display="";
		folder_li.style.display="";
		user_li.style.display="none";
		passw_li.style.display="none";
	} 
	if (type[0].value=='SMB'){
		ip_li.style.display="";
		folder_li.style.display="";
		user_li.style.display="";
		passw_li.style.display="";	
	}
}
