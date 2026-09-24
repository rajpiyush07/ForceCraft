@IsTest
private class WeatherAPITest {   
    // Mock HTTP response
    private class WeatherCalloutMock implements HttpCalloutMock {       
        public HttpResponse respond(HttpRequest req) {           
            HttpResponse res = new HttpResponse();          
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');            
            res.setBody(
                '{"location":{"name":"London"},' +
                '"current":{"temp_c":20.0}}'
            );           
            return res;
        }
    }
    
    @IsTest
    static void testGetWeather() {      
        // Set mock response
        Test.setMock(
            HttpCalloutMock.class,
            new WeatherCalloutMock()
        );      
        Test.startTest();      
        // Call the Apex method
        String result = WeatherAPI.getWeather('London');       
        Test.stopTest(); 
        // Verify the response
        System.assertNotEquals(
            null,
            result,
            'Weather response should not be null'
        );    
        System.assert(
            result.contains('London'),
            'Response should contain the city name'
        );
        System.assert(
            result.contains('temp_c'),
            'Response should contain temperature data'
        );
    }
}