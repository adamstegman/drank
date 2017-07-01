import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';

import { AngularFireDatabase, FirebaseListObservable } from 'angularfire2/database';
import * as moment from 'moment';

import { Drinker } from './drinker';
import { Drink } from './drink';

@Injectable()
export class DrinksService {
  drinks: FirebaseListObservable<Drink[]>;

  constructor(private db: AngularFireDatabase) {
    this.drinks = db.list('/drinks', {
      query: {
        orderByChild: 'time',
        startAt: this.beginningOfDayTimestamp(),
        endAt: this.endOfDayTimestamp()
      }
    });
  }

  addDrink(drinker: Drinker, drank: number): void {
    this.drinks.push({drinkerKey: drinker.$key, amount: drank, time: moment.utc().toJSON()});
  }

  getDrinks(drinker: Drinker): Observable<Drink[]> {
    return this.drinks.
      map(drinks => drinks.filter(drink => drink.drinkerKey == drinker.$key));
  }

  getDrank(drinker: Drinker): Observable<number> {
    return this.getDrinks(drinker).
      map(drinks => drinks.reduce((acc, drink) => acc + drink.amount, 0));
  }

  beginningOfDayTimestamp(): string {
    return moment().startOf('day').utc().toJSON();
  }

  endOfDayTimestamp(): string {
    return moment().endOf('day').utc().toJSON();
  }
}
