/// <reference path="formlib.ts"/>
var rules:Rules = new RegisterRules();
var validator:Validator = new Validator(rules);
$(document).ready(function(){
  validator.setupFormValidation();
});