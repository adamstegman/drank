import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';

import { DrinkersComponent } from './drinkers.component';

const ROUTES = RouterModule.forRoot([
  {path: '', component: DrinkersComponent}
])

@NgModule({
  imports: [ ROUTES ],
  exports: [ RouterModule ]
})
export class AppRoutingModule {}
