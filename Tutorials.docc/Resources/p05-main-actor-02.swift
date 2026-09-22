// Try writing this anywhere outside the class — it won't compile:
//
//   Task.detached {
//       viewModel.statusText = "from the background" // ❌ main actor-isolated
//   }                                                 //    property can't be
//                                                      //    mutated here
//
// @MainActor turns a class of runtime bugs ("Publishing changes from
// background threads") into a compile-time error instead.
