import { Component } from '@angular/core';

export class Drinker {
  id: number;
  name: string;
  drank: number;
}

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'Water Wars';
  drinkers: Drinker[] = [
    {id: 1, name: "Aubrey", drank: 0},
    {id: 2, name: "Adam", drank: 0},
  ];
}
