import { Component } from '@angular/core';
import {IClassroom} from "./interfaces/classroom.interface";

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'T2204M-Angular';

  //Tao danh sach gom 2 lop
  classroomArray : IClassroom[] = [
    {classroomName: 'T2204M', classroomStatus: true},
    {classroomName: 'T2205E', classroomStatus: false}
  ];
}



