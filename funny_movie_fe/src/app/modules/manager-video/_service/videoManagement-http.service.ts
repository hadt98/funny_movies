import { AuthService } from '../../auth';
import { environment } from '../../../../environments/environment';
import { Observable } from 'rxjs';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { VideoDetail } from './videoManagement.service';
const YOUTUBE_API = `${environment.YOUTUBE_API}`;
const YOUTUBE_API_KEY = `${environment.YOUTUBE_API_KEY}`;
const BACKEND_API = `${environment.apiUrl}`;
@Injectable({
  providedIn: 'root',
})
export class VideoManagementHttpService {
  constructor(private http: HttpClient, private authService: AuthService) {}
  // upload video
  checkVideoUrl(link: string): Observable<any> {
    const token = this.authService.getAuthFromLocalStorage().token;
    const httpHeaders = new HttpHeaders({
      Authorization: `Bearer ${token}`,
    });
    return this.http.get<any>(`${BACKEND_API}/api/v1/videos/youtube_info`, {
      params: {
        link,
      },
      headers: httpHeaders,
    });
  }
  saveVideo(link): Observable<any> {
    const token = this.authService.getAuthFromLocalStorage().token;
    const httpHeaders = new HttpHeaders({
      Authorization: `Bearer ${token}`,
    });
    const params = {
      link
    };

    return this.http.post<any>(`${BACKEND_API}/api/v1/videos`, params, {
      headers: httpHeaders,
    });
  }

  getBlockTime(et?: string): Observable<any> {
    const token = this.authService.getAuthFromLocalStorage()?.token;
    let headers = {};
    if (token){
      headers = {
        Authorization: `Bearer ${token}`,
      };
    }
    const httpHeaders = new HttpHeaders(headers);

    return this.http.get<any>(`${BACKEND_API}/videos/public/getByBlockTime`, {
      headers: httpHeaders,
      params: {
        et,
      },
    });
  }

  getVideo(page, pageSize): Observable<any>{
    const token = this.authService.getAuthFromLocalStorage()?.token;
    let headers = {};
    if (token){
      headers = {
        Authorization: `Bearer ${token}`,
      };
    }
    const httpHeaders = new HttpHeaders(headers);
    const params = {
      page,
      per_page: pageSize
    };
    return this.http.get<any>(`${BACKEND_API}/api/v1/videos/mine`, {
      headers: httpHeaders,
      params,
    });
  }

  getPublicVideos(page, pageSize): Observable<any> {
    // const token = this.authService.getAuthFromLocalStorage()?.token;
    // let headers = {};
    // if (token){
    //   headers = {
    //     Authorization: `Bearer ${token}`,
    //   };
    // }
    const httpHeaders = new HttpHeaders({});
    const params = {
      page,
      per_page: pageSize
    };
    return this.http.get<any>(`${BACKEND_API}/api/v1/public/videos`, {
      headers: httpHeaders,
      params,
    });
  }


  emojiVideo(payload: any): Observable<any> {
    const token = this.authService.getAuthFromLocalStorage().token;
    const httpHeaders = new HttpHeaders({
      Authorization: `Bearer ${token}`,
    });

    return this.http.post<any>(
      `${BACKEND_API}/videos/emoji-video`,
      payload,
      {
        headers: httpHeaders,
      });
  }
}
