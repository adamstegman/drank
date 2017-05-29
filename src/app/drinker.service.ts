import { Injectable } from '@angular/core';

import { Drinker } from './drinker';
import { DRINKERS } from './mock-drinkers';

@Injectable()
export class DrinkerService {
  getDrinkers(): Promise<Drinker[]> {
    return Promise.resolve(DRINKERS);
  }
}
