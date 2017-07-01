import { Component } from '@angular/core';
import { OnInit } from '@angular/core';
import { Observable } from 'rxjs/Observable';

import { AngularFireDatabase, FirebaseListObservable } from 'angularfire2/database';

import { DrinksService } from './drinks.service';
import { Drinker } from './drinker';

@Component({
  selector: 'drinkers',
  templateUrl: './drinkers.component.html',
  styleUrls: ['./drinkers.component.css']
})
export class DrinkersComponent {
  drinkers: FirebaseListObservable<Drinker[]>;
  drank: { [drinkerKey: string]: Observable<number> };

  constructor(private db: AngularFireDatabase, private drinksService: DrinksService) {
    this.drinkers = db.list('/drinkers');
    this.drank = {};
  }

  addDrink(drinker: Drinker, drank: number): void {
    this.drinksService.addDrink(drinker, drank);
  }

  getDrank(drinker: Drinker): Observable<number> {
    if (!this.drank.hasOwnProperty(drinker.$key)) {
      this.drank[drinker.$key] = this.drinksService.getDrank(drinker);
    }
    return this.drank[drinker.$key];
  }
}
