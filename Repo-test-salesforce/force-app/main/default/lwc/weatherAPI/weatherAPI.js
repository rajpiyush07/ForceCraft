import { LightningElement } from 'lwc';
import getWeather from '@salesforce/apex/WeatherAPI.getWeather';

export default class WeatherAPI extends LightningElement {
    city = '';
    condition = '';
    imageURL = '';
    
    WeatherAPI() {
        console.log('qwertyuiop');
        alert('112233');
    }
    
    handleonchange(event) {
        this.city = event.target.value;
    }
    buttonClick() {
        alert('abced');
        getWeather({ city: this.city })
            .then(result => {
               console.log('API Response = ', result);
                const data = JSON.parse(result);
                this.condition = data.current.condition.text;
                let icon = data.current.condition.icon;
                console.log('Original Icon = ', icon);
                // Convert relative URL to full HTTPS URL
                if(icon.startsWith('//')){
                    icon = 'https:' + icon;
                }
                this.imageURL = icon;
                console.log('Final Icon URL = ', this.imageURL);
            })
            .catch(error => {
                console.error(error);
                this.condition = 'No matching location found.';
                this.imageURL = '';
            });
    }
}