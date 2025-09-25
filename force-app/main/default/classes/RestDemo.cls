
@RestResource(urlMapping='/home')
global with sharing class RestDemo {
    
    @HttpGet
    global static String hello()
    {
    return 'Hello';
    }
}