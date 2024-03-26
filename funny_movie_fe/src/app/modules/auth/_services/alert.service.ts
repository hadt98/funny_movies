import { Injectable } from '@angular/core';
import { Observable, Observer } from 'rxjs';
import { webSocket, WebSocketSubject } from 'rxjs/webSocket';
import {environment} from "../../../../environments/environment";
import {AuthService} from "./auth.service";


@Injectable({
    providedIn: 'root' // Make the service available throughout the application
})
export class AlertService {

    private socket$: WebSocketSubject<any>;

    constructor() { }

    public connect(private auth: AuthService): Observable<any> {
        // this.auth.currentUserSubject.subscribe(user => {})

        const WEBSOCKET_URL = `${environment.wsUrl}/cable?token=`;

        return new Observable((observer: Observer<any>) => {
            if (!this.socket$) {
                this.socket$ = webSocket(WEBSOCKET_URL);
                this.socket$.subscribe(
                    (data) => observer.next(data),
                    (err) => observer.error(err),
                    () => observer.complete()
                );
            }
            return () => this.socket$.unsubscribe();
        });
    }

    public sendMessage(message: any) {
        if (this.socket$) {
            this.socket$.next(message);
        }
    }
}
