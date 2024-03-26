import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import {VideoDetail, VideoManagementService, } from './../_service/videoManagement.service';
import {ChangeDetectorRef, Component, OnChanges, OnInit, SimpleChanges} from '@angular/core';
import {VideoManagementHttpService} from '../_service/videoManagement-http.service';
import {ToastrService} from 'ngx-toastr';
import {Router} from '@angular/router';
import { RouterModule, Routes } from '@angular/router';

@Component({
  selector: 'app-upload-video',
  templateUrl: './upload-video.component.html',
  styleUrls: ['./upload-video.component.scss'],
})
export class UploadVideoComponent implements OnInit, OnChanges {
  checkVideoUrlForm: FormGroup;
  createVideoForm: FormGroup;
  constructor(
    private videoService: VideoManagementService,
    private formBuilder: FormBuilder,
    private videoManagementHttpService: VideoManagementHttpService,
    private changeDetectorRefs: ChangeDetectorRef,
    private toastr: ToastrService,
    private router: Router
  ) {}


  ngOnInit(): void {
    this.initForm();
  }

  ngOnChanges(changes: SimpleChanges): void {

  }
  initForm() {
    this.checkVideoUrlForm = this.formBuilder.group({
      link: ['', Validators.compose([Validators.required])],
    });

    this.createVideoForm = this.formBuilder.group({
      video_id: ['', Validators.compose([Validators.required])],
      title: ['', Validators.compose([Validators.required])],
      description: ['', Validators.compose([Validators.required])],
      link: ['', Validators.compose([Validators.required])],
    });
  }
  resetValue() {
  }
  getParameterByName(name, link) {
    name = name.replace(/[\[\]]/g, '\\$&');
    const regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
        results = regex.exec(link);
    if (!results) { return null; }
    if (!results[2]) { return ''; }
    return decodeURIComponent(results[2].replace(/\+/g, ' '));
  }

  checkVideoUrl() {
    const link = this.checkVideoUrlForm.get('link').value;
    const videoId = this.getParameterByName('v', link);
    if (!videoId){
      this.toastr.error('link video error');
      return;
    }
    this.videoManagementHttpService
      .checkVideoUrl(link)
      .subscribe(
        (data) => {
          this.createVideoForm.patchValue({
            video_id: data.video_id,
            title:  data.title,
            description: data.description,
            link: link
          });
          this.toastr.success('link is valid');
        },
        error => {
          this.toastr.error('Có lỗi xảy ra'); // TODO => convert error sang str
        },
        () => {
          this.changeDetectorRefs.detectChanges();
        }
      );
  }
  onSubmit() {
    const data: VideoDetail = this.createVideoForm.value;
    this.videoService.saveVideo(data.link).subscribe(data => {
      this.router.navigate(['/manager-video']);
    });
  }
}
