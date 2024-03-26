import { Observable } from 'rxjs';
import {
  VideoDetail,
  VideoManagementService,
} from './../_service/videoManagement.service';
import { Component, OnInit } from '@angular/core';
import {VideoManagementHttpService} from '../_service/videoManagement-http.service';

@Component({
  selector: 'app-list-video',
  templateUrl: './list-video.component.html',
  styleUrls: ['./list-video.component.scss'],
})
export class ListVideoComponent implements OnInit {
  listVideos: VideoDetail[];
  preBlockNumber = '';
  nextBlockNumber = '';
  constructor(
    private videoService: VideoManagementService,
    private videoHttpService: VideoManagementHttpService) {}

  ngOnInit(): void {
    const tag = document.createElement('script');
    tag.src = 'https://www.youtube.com/iframe_api';
    document.body.appendChild(tag);
    this.getListVideo();
  }
  getListVideo() {
    this.videoHttpService.getVideo(1, 9999).subscribe((resp) => {
      this.listVideos = resp.data;
    });
  }
}
