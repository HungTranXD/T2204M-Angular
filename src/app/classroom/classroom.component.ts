import {Component, Input} from "@angular/core";
import {IStudent} from "../interfaces/student.interface";
import {IClassroom} from "../interfaces/classroom.interface";

@Component({
  selector: 'app-classroom',
  templateUrl: './classroom.component.html'
})

export class ClassroomComponent {
  className = 'T2204M';
  classStatus = true;

  //Tao object bao gom 2 properties cua classroom
  @Input()
  classroomData !: IClassroom;



  studentNames = [
    'SV Nguyen Van An',
    'SV Vu The Kinh'
  ];
  studentAges = [18, 21];

  //Tao 1 danh sach sinh vien
  studentArray : IStudent[] = [
    {studentName: 'SV Nguyen Van An', studentAge: 18, phoneNumber:'0123456'},
    {studentName: 'SV Vu The Kinh', studentAge: 21, phoneNumber:'0874843'}
  ];

  teacherNames = [
    'Nguyen Van An',
    'Hoang Thi Binh',
    'Vu Thai Nam'
  ];
  subjectNames = [
    'LBEP',
    'HCJS',
    'AJS',
    'DNS'
  ];
  changeName(){
    this.className = 'T2203E';
  }
  changeStatus() {
    this.classStatus = !this.classStatus;
  }
}


