import { Component } from '@angular/core';
import { Drinker } from './drinker';

const DRINKERS: Drinker[] = [
  new Drinker(1, "Aubrey"),
  new Drinker(2, "Adam"),
];

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'Water Wars';
  drinkers: Drinker[] = DRINKERS;
}
