import {Component, OnInit} from '@angular/core';
import {VideoManagementHttpService} from '../manager-video/_service/videoManagement-http.service';
import {ChangeDetectorRef} from '@angular/core';
import {ToastrService} from 'ngx-toastr';

enum EMOTION_TYPE {
  LIKE = 'LIKE',
  DISLIKE = 'DISLIKE',
  LOVE = 'LOVE',
  ANGRY = 'ANGRY',
  WOW = 'WOW',
  LOL = 'LOL',
}

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {

  hiddenVideo = false;
  videos = [];
  private preEndTime: null;
  private currentBlock = null;

  listEmotion = [];
  isLoading = false;
  currentPage: number;

  constructor(
    private videoManagementHttpService: VideoManagementHttpService,
    private changeDetectorRefs: ChangeDetectorRef,
    private toastr: ToastrService
  ) {
  }

  ngOnInit(): void {
    this.listEmotion = Object.entries(EMOTION_TYPE).map(([key, val]) => ({key, value: val}));
    // this.videos = [];
    // this.videos.push({
    //   sourceId : "S7ElVoYZN0g",
    //   sourceType : "YOUTUBE",
    //   title: "title",
    //   description: "description",
    //   ownerId: "",
    //   ownerEmail: "hungnm",
    //   currentEmoji: "LIKE",
    //   emojiCount : {
    //     LIKE : 10,
    //     DISLIKE : 10,
    //     HEART: 10,
    //     SMILE: 10
    //   },
    // });
    this.currentPage = 1;
    this.videos = [];
    this.getVideos();
  }

  nextVideos() {
    this.currentPage++;
    this.getVideos();
  }

  getVideos() {
    this.videoManagementHttpService.getPublicVideos(this.currentPage, 20).subscribe(resp => {
        const data = resp.data;
        if (!data || data.count <= 0) {
          this.toastr.error('videos not found');
          return;
        }

        const ids = this.videos.map(x => x.id);

        data.forEach(item => {
          if (ids.indexOf(item) < 0) {
            this.videos.push(item);
          }
        });
      }
      ,
      err => {
        this.toastr.error('unknown error');

      },
      () => {
        this.isLoading = false;
        this.changeDetectorRefs.detectChanges();
      });
  }

  nextBlock() {
    const et = this.preEndTime ?? '';
    this.isLoading = true;
    this.videoManagementHttpService.getBlockTime(et).subscribe(
      data => {
        if (data.id) {
          this.currentBlock = data;
          this.videos = [...this.videos, ...data.videos];
          this.preEndTime = data.preEndTime;
        } else {
          this.toastr.error('het block');
        }
      },
      err => {
        this.toastr.error('het block');

      },
      () => {
        this.isLoading = false;
        this.changeDetectorRefs.detectChanges();
      }
    );
  }

  emojiVideo(video, emojiType) {
    const payload = {
      emojiType,
      videoId: video?.id
    };
    this.videoManagementHttpService.emojiVideo(payload).subscribe(
      data => {

        if (video.emojiCount == null) {
          video.emojiCount = {};
        }

        if (video.emojiCount && video.currentUserEmoji && video.emojiCount[video.currentUserEmoji] && video.emojiCount[video.currentUserEmoji] > 0) {
          video.emojiCount[video.currentUserEmoji] = video.emojiCount[video.currentUserEmoji] - 1;
        }

        video.currentUserEmoji = emojiType;
        video.emojiCount[emojiType] = (video.emojiCount[emojiType] || 0) + 1;
      },
      error => {

      },
      () => {
        this.changeDetectorRefs.detectChanges();
      }
    );
  }

}
