import { Component } from '@angular/core';
import { OnInit } from '@angular/core';

import { AngularFireDatabase, FirebaseListObservable } from 'angularfire2/database';

import { Drinker } from './drinker';

@Component({
  selector: 'drinkers',
  templateUrl: './drinkers.component.html',
  styleUrls: ['./drinkers.component.css']
})
export class DrinkersComponent {
  drinkers: FirebaseListObservable<any[]>;

  constructor(private db: AngularFireDatabase) {
    this.drinkers = db.list('/drinkers');
  }

  addDrink(drinker: Drinker, drank: number): void {
    drinker.drank += drank;
    this.drinkers.update(drinker.$key, drinker);
  }
}
