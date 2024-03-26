import { NgModule } from "@angular/core";
import { Routes, RouterModule } from "@angular/router";
import { LayoutComponent } from "./_layout/layout.component";
import { HomeComponent } from "../modules/home/home.component";
import { AuthGuard } from "../modules/auth/_services/auth.guard";

const routes: Routes = [
  {
    path: "",
    component: LayoutComponent,
    children: [
      {
        path: "home",
        component: HomeComponent,
      },
      {
        path: "manager-video",
        canActivate: [AuthGuard],
        loadChildren: () =>
          import("../modules/manager-video/video-management.module").then(
            (m) => m.VideoManagementModule
          ),
      },
      {
        path: "",
        redirectTo: "home",
        pathMatch: "full",
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
export class PagesRoutingModule {}
