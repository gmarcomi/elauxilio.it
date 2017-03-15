/// <reference path="formlib.ts"/>
var validator: Validator = new Validator(new PasswordRules());
$(document).ready(function(){
  validator.setupFormValidation();
});