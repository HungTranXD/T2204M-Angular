import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppComponent } from './app.component';
import {StudentComponent} from "./student/student.component";
import {ClassroomComponent} from "./classroom/classroom.component";
import {FormsModule} from "@angular/forms";
import {CurrentWeatherComponent} from "./current-weather/current-weather.component";
import {HttpClientModule} from "@angular/common/http";
import {ForecastComponent} from "./forecast/forecast.component";

@NgModule({
  declarations: [
    AppComponent,
    StudentComponent,
    ClassroomComponent,
    CurrentWeatherComponent,
    ForecastComponent
  ],
  imports: [
    BrowserModule, FormsModule,
    HttpClientModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
