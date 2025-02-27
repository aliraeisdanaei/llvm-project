; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=slp-vectorizer -mtriple=x86_64-apple-macosx10.9.0 -mcpu=corei7-avx -S < %s | FileCheck %s
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.9.0"


; This test used to crash because we were following phi chains incorrectly.
; We used indices to get the incoming value of two phi nodes rather than
; incoming block lookup.
; This can give wrong results when the ordering of incoming
; edges in the two phi nodes don't match.

%0 = type { %1, %2 }
%1 = type { double, double }
%2 = type { double, double }


;define fastcc void @bar() {
define void @bar(i1 %arg) {
; CHECK-LABEL: @bar(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[I:%.*]] = getelementptr inbounds [[TMP0:%.*]], ptr undef, i64 0, i32 1, i32 0
; CHECK-NEXT:    [[I1:%.*]] = getelementptr inbounds [[TMP0]], ptr undef, i64 0, i32 1, i32 1
; CHECK-NEXT:    [[I2:%.*]] = getelementptr inbounds [[TMP0]], ptr undef, i64 0, i32 1, i32 0
; CHECK-NEXT:    [[I3:%.*]] = getelementptr inbounds [[TMP0]], ptr undef, i64 0, i32 1, i32 1
; CHECK-NEXT:    [[I4:%.*]] = getelementptr inbounds [[TMP0]], ptr undef, i64 0, i32 1, i32 0
; CHECK-NEXT:    br label [[BB6:%.*]]
; CHECK:       bb6:
; CHECK-NEXT:    [[I7:%.*]] = phi double [ 2.800000e+01, [[BB:%.*]] ], [ [[I10:%.*]], [[BB17:%.*]] ], [ [[I10]], [[BB16:%.*]] ], [ [[I10]], [[BB16]] ]
; CHECK-NEXT:    [[I8:%.*]] = phi double [ 1.800000e+01, [[BB]] ], [ [[TMP1:%.*]], [[BB17]] ], [ [[TMP1]], [[BB16]] ], [ [[TMP1]], [[BB16]] ]
; CHECK-NEXT:    store double [[I8]], ptr [[I]], align 8
; CHECK-NEXT:    store double [[I7]], ptr [[I1]], align 8
; CHECK-NEXT:    [[I10]] = load double, ptr [[I3]], align 8
; CHECK-NEXT:    [[TMP0]] = load <2 x double>, ptr [[I2]], align 8
; CHECK-NEXT:    br i1 %arg, label [[BB11:%.*]], label [[BB12:%.*]]
; CHECK:       bb11:
; CHECK-NEXT:    ret void
; CHECK:       bb12:
; CHECK-NEXT:    store <2 x double> [[TMP0]], ptr [[I4]], align 8
; CHECK-NEXT:    br i1 %arg, label [[BB13:%.*]], label [[BB14:%.*]]
; CHECK:       bb13:
; CHECK-NEXT:    br label [[BB14]]
; CHECK:       bb14:
; CHECK-NEXT:    br i1 %arg, label [[BB15:%.*]], label [[BB16]]
; CHECK:       bb15:
; CHECK-NEXT:    unreachable
; CHECK:       bb16:
; CHECK-NEXT:    [[TMP1]] = extractelement <2 x double> [[TMP0]], i32 0
; CHECK-NEXT:    switch i32 undef, label [[BB17]] [
; CHECK-NEXT:      i32 32, label [[BB6]]
; CHECK-NEXT:      i32 103, label [[BB6]]
; CHECK-NEXT:    ]
; CHECK:       bb17:
; CHECK-NEXT:    br i1 %arg, label [[BB6]], label [[BB18:%.*]]
; CHECK:       bb18:
; CHECK-NEXT:    unreachable
;
bb:
  %i = getelementptr inbounds %0, ptr undef, i64 0, i32 1, i32 0
  %i1 = getelementptr inbounds %0, ptr undef, i64 0, i32 1, i32 1
  %i2 = getelementptr inbounds %0, ptr undef, i64 0, i32 1, i32 0
  %i3 = getelementptr inbounds %0, ptr undef, i64 0, i32 1, i32 1
  %i4 = getelementptr inbounds %0, ptr undef, i64 0, i32 1, i32 0
  %i5 = getelementptr inbounds %0, ptr undef, i64 0, i32 1, i32 1
  br label %bb6

bb6:                                              ; preds = %bb17, %bb16, %bb16, %bb
  %i7 = phi double [ 2.800000e+01, %bb ], [ %i10, %bb17 ], [ %i10, %bb16 ], [ %i10, %bb16 ]
  %i8 = phi double [ 1.800000e+01, %bb ], [ %i9, %bb17 ], [ %i9, %bb16 ], [ %i9, %bb16 ]
  store double %i8, ptr %i, align 8
  store double %i7, ptr %i1, align 8
  %i9 = load double, ptr %i2, align 8
  %i10 = load double, ptr %i3, align 8
  br i1 %arg, label %bb11, label %bb12

bb11:                                             ; preds = %bb6
  ret void

bb12:                                             ; preds = %bb6
  store double %i9, ptr %i4, align 8
  store double %i10, ptr %i5, align 8
  br i1 %arg, label %bb13, label %bb14

bb13:                                             ; preds = %bb12
  br label %bb14

bb14:                                             ; preds = %bb13, %bb12
  br i1 %arg, label %bb15, label %bb16

bb15:                                             ; preds = %bb14
  unreachable

bb16:                                             ; preds = %bb14
  switch i32 undef, label %bb17 [
  i32 32, label %bb6
  i32 103, label %bb6
  ]

bb17:                                             ; preds = %bb16
  br i1 %arg, label %bb6, label %bb18

bb18:                                             ; preds = %bb17
  unreachable
}
