import { Component } from '@angular/core';
import { OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Observable } from 'rxjs/Observable';

import { AngularFireDatabase, FirebaseListObservable } from 'angularfire2/database';
import * as moment from 'moment';

import { DrinksService } from './drinks.service';
import { Drinker } from './drinker';

@Component({
  selector: 'drinkers',
  templateUrl: './drinkers.component.html',
  styleUrls: ['./drinkers.component.css']
})
export class DrinkersComponent implements OnInit {
  drinkers: FirebaseListObservable<Drinker[]>;
  drank: { [drinkerKey: string]: Observable<number> };

  constructor(private route: ActivatedRoute, private db: AngularFireDatabase, private drinksService: DrinksService) {
    this.drinkers = db.list('/drinkers');
    this.drank = {};
  }

  ngOnInit() {
    // Set service query parameters
    this.route.queryParamMap.subscribe({
      next: params => {
        const startAt = params.get('startAt');
        const endAt = params.get('endAt');
        this.drinksService.setDrinkTimestamps(startAt, endAt);
      }
    });
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

  beginningOfWeekTimestamp(): string {
    return moment().startOf('week').utc().toJSON();
  }
}
