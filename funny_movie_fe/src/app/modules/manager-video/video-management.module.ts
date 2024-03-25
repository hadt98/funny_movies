import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { ListVideoComponent } from "./list-video/list-video.component";
import { UploadVideoComponent } from "./upload-video/upload-video.component";
import { ManageVideoRoutingModule } from "./video-management-routing.module";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { HttpClientModule } from "@angular/common/http";
import { YouTubePlayerModule } from "@angular/youtube-player";
@NgModule({
  declarations: [ListVideoComponent, UploadVideoComponent],
  imports: [
    CommonModule,
    ManageVideoRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    YouTubePlayerModule,
  ],
})
export class VideoManagementModule {}
