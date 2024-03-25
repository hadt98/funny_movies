import { NgModule } from "@angular/core";
import { Routes, RouterModule } from "@angular/router";
import { AuthGuard } from "../auth/_services/auth.guard";
import { UploadVideoComponent } from "./upload-video/upload-video.component";
import { ListVideoComponent } from "./list-video/list-video.component";

const routes: Routes = [
  {
    path: "",
    children: [
      {
        path: "upload-video",
        component: UploadVideoComponent,
        pathMatch: "full",
      },
      {
        path: "",
        component: ListVideoComponent,
      },
      {
        path: "**",
        redirectTo: "error/404",
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ManageVideoRoutingModule {}
