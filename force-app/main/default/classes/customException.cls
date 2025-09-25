public with sharing class customException extends Exception {
    public String errorType {get;set;}
    public String operation {get;set;}

    public customException(String errType, String op) {
        this.errorType = errType;
        this.operation = op;
    }
}