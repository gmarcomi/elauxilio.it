/// <reference path="../lib/jquery.d.ts"/>
/// <reference path="../lib/jquery.validation.d.ts"/>
interface Rules{
  getRules():Object;
  getMessages():Object;
}
class RegisterRules implements Rules{
  getRules(){
    return {
        'username' : {
          required: true,
          minlength: 5
        },
        'password' : {
          required: true,
          minlength: 5
        },
        'name' : {
          required: true
        },
        'last' : {
          required: true
        }
      };   
  }
  getMessages(){
    return {
        'username' : {
          required: "Campo <span lang=\"en\">username</span> obbligatorio",
          minlength: "<span lang=\"en\">Username</span> minore di 5 caratteri"
        },
        'password' : {
          required : "Il campo <span lang=\"en\">password</span> è obbligatorio",
          minlength : "Scegli una <span lang=\"en\">password</span> di almeno 5 caratteri"
        },
        'name' : {
          required: "Campo nome obbligatorio"
        },
        'last' : {
          required: "Campo cognome obbligatorio"
        }
      };  
  }
}
class PasswordRules implements Rules{
  getRules(){
    return {
      'opassword':{
        required: true
      },
      'password':{
        required: true,
        minlength: 5
      },
      'cpassword':{
        required: true,
        equalTo: '#password'
      }
    }
  }
  getMessages(){
    return {
      'opassword':{
        required: "Vecchia <span lang=\"en\">password</span> obbligatoria"
      },
      'password':{
        required: "La nuova <span lang=\"en\">password</xml> non può essere vuota",
        minlength: "<span lang=\"en\">Password</span> troppo corta, sono necessari almeno 5 caratteri"
      },
      'cpassword':{
        required: "Conferma <span lang=\"en\">password</xml> non può essere vuota",
        equalTo: "Le due <span lang=\"en\">password</span> non coincidono"
      }
    }
  }
}
class Validator{
  private regRules : Rules;
  constructor(regRules : Rules){
    this.regRules = regRules;
  }
  setupFormValidation(){
    $("#form_ins").validate({
      rules: this.regRules.getRules(),
      messages : this.regRules.getMessages(),
      submitHandler : function(form) {
          form.submit();
        }  
    });
  }
}