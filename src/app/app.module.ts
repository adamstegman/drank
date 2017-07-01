import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';

import { FloorPipe } from './floor.pipe';

import { AppRoutingModule } from './app-routing.module';

import { AppComponent } from './app.component';
import { DrinkersComponent } from './drinkers.component';
import { DrinksService } from './drinks.service';

import { AngularFireModule } from 'angularfire2';
import { AngularFireDatabaseModule } from 'angularfire2/database';

import { environment } from '../environments/environment';

@NgModule({
  declarations: [
    AppComponent,
    DrinkersComponent,
    FloorPipe
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule,
    AppRoutingModule,
    AngularFireModule.initializeApp(environment.firebase, "drank"),
    AngularFireDatabaseModule
  ],
  providers: [DrinksService],
  bootstrap: [AppComponent]
})
export class AppModule { }
