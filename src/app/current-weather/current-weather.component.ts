import {Component} from "@angular/core";
import {ICurrentWeather} from "../interfaces/current-weather.interface";
import {HttpClient, HttpParams} from "@angular/common/http";

@Component({
  selector: 'app-currentweather',
  templateUrl: './current-weather.component.html'
})

export class CurrentWeatherComponent {
  data : ICurrentWeather | undefined;
  cityCode = 'Hanoi';
  //Lay du lieu tu API cho vao bien data
  constructor(private http: HttpClient) { //Ham nay tu dong chay sau khi tao component
  }

  ngOnInit() { //Ham nay tu dong chay say khi print html xong
    this.changeCity();
  }

  changeCity() {
    const url = 'https://api.openweathermap.org/data/2.5/weather';
    let params = new HttpParams();
    params = params.append('q',this.cityCode);
    params = params.append('appid','09a71427c59d38d6a34f89b47d75975c');
    params = params.append('units','metric');
    this.http.get<ICurrentWeather>(url,{params: params})
      .subscribe(value => {
        this.data = value;
      })
  }

}
