// websocket.service.ts

import {Injectable} from '@angular/core';
import {webSocket, WebSocketSubject} from 'rxjs/webSocket';
import {BehaviorSubject, Observable} from 'rxjs';
import {AuthService} from './auth.service';
import {ToastrService} from 'ngx-toastr';
import {environment} from '../../../../environments/environment';
import {UserModel} from '../_models/user.model';
import * as url from 'url';


@Injectable({
    providedIn: 'root'
})
export class WebsocketService {
    private socket$: WebSocketSubject<any>;
    private user$: UserModel;
    private socket: WebSocket;

    constructor(private auth: AuthService, private toast: ToastrService, private window: Window) {
        console.log('websocket');
        // this.socket$ = webSocket('wss://your-websocket-server-url');
        this.auth.currentUserSubject.subscribe(user => {
            console.log('authen');
            if (user) {
                this.connect();
            } else {
                this.closeConnection();
            }
            this.user$ = user;
        });
    }

    private getWsUrl() {
        if (environment.wsUrl) {
            return environment.wsUrl;
        }
        return window.location.origin.replace(/http/g, 'ws');
    }

    public connect() {
        if (!this.user$ || this.socket) {
            return;
        }
        console.log('connect');
        // this.closeConnection();
        const token = this.auth.getAuthFromLocalStorage().token;
        const wsUrl = `${this.getWsUrl()}/cable?token=${token}`;
        this.socket = new WebSocket(wsUrl);

        this.socket.onopen = (event) => {
            console.log('Connected to the Rails server.');
            const msg = {
                command: 'subscribe',
                identifier: JSON.stringify({
                    id: 1,
                    channel: 'AlertsChannel'
                })
            };
            this.socket.send(JSON.stringify(msg));
        };

        this.socket.onmessage = (event) => {
            const data = JSON.parse(event.data);
            this.handleData(data);
        };

        this.socket.onclose = (event) => {
            console.log('Disconnected from the server.');
        };

        this.socket.onerror = (error) => {
            console.log('WebSocket error observed:', error);
        };
    }

    public handleData(data) {
        if (data.type === 'ping') {
            return;
        }
        if (data.message) {
            console.log(data.message);
            const identifier = JSON.parse(data.identifier);
            const message = data.message;
            console.log('identifier', identifier);
            console.log('message', message);
            if (identifier.channel === 'AlertsChannel') {
                if (message.owner !== this.user$.email){
                    this.toast.info(`user: ${message.owner} create new video: ` + message.title);
                }
            }
        }
    }

    public closeConnection(): void {
        if (this.socket) {
            this.socket.close();
        }
    }
}
