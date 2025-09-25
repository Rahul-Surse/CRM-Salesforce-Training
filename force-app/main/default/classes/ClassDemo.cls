@RestResource(urlMapping='/Home/*')
global with sharing class ClassDemo {
    @HttpGet
    global static string ClassDemo() {

            return 'Connected well';
    }
}