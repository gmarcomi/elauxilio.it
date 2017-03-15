$(document).ready(function(){
  //rimozione classe necessaria alla renderizzazione del menu con js disattivato
	var menu = "no";
	$("#bar").removeClass("accessmenu");
	$("#btn-responsive-menu").removeClass("accessbutton");
	$(".padding").addClass("do");
	$("#header").addClass("fixed");
	$("#btn-responsive-menu").click(function() {
		if(menu == "si"){
		  $("#bar").removeClass("show");
			menu = "no";
		}
		else{
		  $("#bar").addClass("show");
			menu = "si";
		}
  });
});
