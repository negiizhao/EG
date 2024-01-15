import EuclideanGeometry.Foundation.Construction.Polygon.Quadrilateral
import EuclideanGeometry.Foundation.Construction.Polygon.Trapezoid
import EuclideanGeometry.Foundation.Tactic.Congruence.Congruence
import EuclideanGeometry.Foundation.Axiom.Triangle.Basic
import EuclideanGeometry.Foundation.Axiom.Triangle.Congruence
import EuclideanGeometry.Foundation.Axiom.Position.Angle_trash
import EuclideanGeometry.Foundation.Axiom.Position.Angle_ex
import EuclideanGeometry.Foundation.Axiom.Position.Angle
import EuclideanGeometry.Foundation.Axiom.Linear.Parallel_trash

noncomputable section
namespace EuclidGeom

-- `Add class parallelogram and state every theorem in structure`

/-
There're some structural problems need further discuss.
1. In our earlier implement, we tried to claim most theorems in two different form. One of them accept arguments like (A B C D : P) ((QDR A B C D) satisfies...), the other accept arguments like (qdr : Quadrilateral) (qdr satisfieds...). We called first one 'variant'. But it's seems that we can delete all 'variant's and force user to use theorems in format of (some_prg_theorem (QDR A B C D) some_conditions), in this way we can get rid of variants.
2. We have quite much criteria from Prg and/or Qdr_nd to PrgND. For user's ease, we need to provide some make methods. It's clear we should have a method like (PRG A B C D (QDR A B C D is PrgND)), It's the most intuitive make method. We should discuss the necessity of other make methods. For example, do we need a method accepts arguments qdr_cvx and (qdr_cvx satisfies IsPara)?
3. In other structures we define predicate IsXXX then define structure XXX with it's element IsXXX. Now the PrgND is not involving new predicate, so the definition of 'IsPrgND' is not related to structure PrgND naturally. How to solve this? Shall we simply provide more instances?
4. the naming of predicate currently called 'non_triv_PRG_nd' and 'IsPara_PRG_nd', and the naming of 'IsPara' and 'non_triv' needs discuss.
-/

/-



Recall certain definitions concerning quadrilaterals:

A QDR consists of four points; it is the generalized quadrilateral formed by these four points.

A QDR_nd is QDR that the points that adjacent is not same, namely point₂ ≠ point₁, point₃ ≠ point₂, point₄ ≠ point₃, and point₁ ≠ point₁.

We take notice that, by the well-known fact that non-trivial parallelograms are indeed convex, and considering the fine qualities of convex quadrilaterals, we decide to define parallelogram_nds as a parallelogram that is convex, while the class of parallelograms permit degenerate cases. In this way, the structure of parallelogram_nd becomes natural in both aspects of quadrilaterals and parallelograms. We do take notice that there are more straightforward ways to descibe parallelograms, such as IsPara and non_triv mentioned later. So it is due to user-friendliness that we leave quite a number of shortcuts to ease theorem-proving.

In this section we define two types of parallelograms. 'parallel_nd' deals with those quadrilaterals we commomly call parallelogram (convex), and 'parallel' with more general cases (we permite degenerate cases).

-/

/-- A quadrilateral satisfies non_triv if every 3 vertices are not colinear. -/
@[pp_dot]
structure Quadrilateral.non_triv {P : Type _} [EuclideanPlane P] (qdr : Quadrilateral P) : Prop where
  not_colinear₁₂₃: ( ¬ colinear qdr.point₁ qdr.point₂ qdr.point₃)
  not_colinear₂₃₄: ( ¬ colinear qdr.point₂ qdr.point₃ qdr.point₄)
  not_colinear₃₄₁: ( ¬ colinear qdr.point₃ qdr.point₄ qdr.point₁)
  not_colinear₄₁₂: ( ¬ colinear qdr.point₄ qdr.point₁ qdr.point₂)

-- scoped postfix : 50 "IsPrg_non_triv" => Quadrilateral.non_triv

/-- A quadrilateral_nd satisfies IsPara if two sets of opposite sides are parallel respectively. -/
@[pp_dot]
def Quadrilateral_nd.IsPara {P : Type _} [EuclideanPlane P] (qdr_nd : Quadrilateral_nd P) : Prop := ( qdr_nd.edge_nd₁₂ ∥ qdr_nd.edge_nd₃₄) ∧ (qdr_nd.edge_nd₁₄ ∥ qdr_nd.edge_nd₂₃)

-- scoped postfix : 50 "IsPara" => Quadrilateral_nd.para

/-- A quadrilateral satisfies IsPara if it is a quadrilateral_nd and satisfies IsPara as a quadrilateral_nd. -/
@[pp_dot]
def Quadrilateral.IsPara {P : Type _} [EuclideanPlane P] (qdr : Quadrilateral P) : Prop := by
  by_cases h : qdr.IsND
  · exact (Quadrilateral_nd.mk_is_nd h).IsPara
  · exact False

/-- A quadrilateral is called parallelogram if VEC qdr.point₁ qdr.point₂ = VEC qdr.point₄ qdr.point₃.-/
@[pp_dot]
def Quadrilateral.IsParallelogram {P : Type _} [EuclideanPlane P] (qdr : Quadrilateral P) : Prop := VEC qdr.point₁ qdr.point₂ = VEC qdr.point₄ qdr.point₃

scoped postfix : 50 "IsPrg" => Quadrilateral.IsParallelogram

-- `shall we define this?`
-- /-- A quadrilateral_nd is called parallelogram if VEC qdr.point₁ qdr.point₂ = VEC qdr.point₄ qdr.point₃.-/
-- @[pp_dot]
-- def Quadrilateral_nd.IsParallelogram {P : Type _} [EuclideanPlane P] (qdr_nd : Quadrilateral_nd P) : Prop := VEC qdr_nd.point₁ qdr_nd.point₂ = VEC qdr_nd.point₄ qdr_nd.point₃

-- scoped postfix : 50 "nd_IsParallelogram" => Quadrilateral_nd.IsParallelogram

/-- We define parallelogram as a structure. -/
@[ext]
structure Parallelogram (P : Type _) [EuclideanPlane P] extends Quadrilateral P where
  is_parallelogram : toQuadrilateral IsPrg

/-- Make a parallelogram with 4 points on a plane, and using condition IsPrg. -/
def Parallelogram.mk_pt_pt_pt_pt {P : Type _} [EuclideanPlane P] (A B C D : P) (h : (QDR A B C D) IsPrg) : Parallelogram P where
  toQuadrilateral := (QDR A B C D)
  is_parallelogram := h

scoped notation "PRG" => Parallelogram.mk_pt_pt_pt_pt

/-- Make a parallelogram with a quadrilateral, and using condition IsPrg. -/
def mk_parallelogram {P : Type _} [EuclideanPlane P] {qdr : Quadrilateral P} (h : qdr IsPrg) : Parallelogram P where
  toQuadrilateral := qdr
  is_parallelogram := h

/-- A parallelogram which satisfies Prallelogram_non_triv satisfies IsPara. -/
theorem IsPara_of_non_triv {P : Type _} [EuclideanPlane P] {prg : Parallelogram P} (non_triv: prg.non_triv): prg.IsPara:= by
  sorry

/-- A parallelogram which satisfies Prallelogram_non_triv is convex. -/
theorem convex_of_non_triv {P : Type _} [EuclideanPlane P] {prg : Parallelogram P} (non_triv: prg.non_triv): prg.IsConvex:= by sorry

/-- We define parallelogram_nd as a structure. -/
@[ext]
structure ParallelogramND (P : Type _) [EuclideanPlane P] extends Quadrilateral_cvx P, Parallelogram P

/-- A quadrilateral is parallelogram_nd if it is both convex and satisfies qualities of a parallelogram. This definition is in agreement with the structure above. -/
@[pp_dot]
def Quadrilateral.IsParallelogramND {P : Type _} [EuclideanPlane P] (qdr : Quadrilateral P) : Prop := qdr IsConvex ∧ qdr IsPrg

scoped postfix : 50 "IsPrgND" => Quadrilateral.IsParallelogramND

-- /-- A quadrilateral_nd is parallelogram_nd if its toQuadrilateral is both convex and satisfies qualities of a parallelogram. -/
-- @[pp_dot]
-- def Quadrilateral_nd.IsParallelogramND {P : Type _} [EuclideanPlane P] (qdr_nd : Quadrilateral_nd P) : Prop := Quadrilateral.IsParallelogramND qdr_nd.toQuadrilateral

-- scoped postfix : 50 "nd_IsParallelogramND" => Quadrilateral_nd.IsParallelogramND

/-- A parallelogram_nd satisfies non_triv. -/
theorem non_triv_of_parallelogramND {P : Type _} [EuclideanPlane P] (prg_nd : ParallelogramND P) : prg_nd.non_triv := by
  sorry

/-- A parallelogram_nd satisfies non_triv. -/
theorem non_triv_of_parallelogramND_variant {P : Type _} [EuclideanPlane P] {A B C D : P} (h : (QDR A B C D).IsParallelogramND) : (QDR A B C D).non_triv := by
  sorry

/-- A parallelogram_nd satisfies IsPara. -/
theorem IsPara_of_parallelogramND {P : Type _} [EuclideanPlane P] (prg_nd : ParallelogramND P) : prg_nd.IsPara := by
  sorry

-- `the necessity of variant theorems needs further discuss`
/-- A parallelogram_nd satisfies IsPara. -/
theorem IsPara_of_parallelogramND_variant {P : Type _} [EuclideanPlane P] {A B C D : P} (h : (QDR A B C D) IsPrgND) : (QDR A B C D).IsPara := by
  sorry

def ParallelogramND.mk_pt_pt_pt_pt {P : Type _} [EuclideanPlane P] (A B C D : P) (h: (QDR A B C D) IsPrgND) : ParallelogramND P where
  toQuadrilateral := (QDR A B C D)
  nd := h.left; convex := h.left
  is_parallelogram := h.right

scoped notation "PRG_nd" => ParallelogramND.mk_pt_pt_pt_pt

/-- Using the property above, we leave such a shortcut in a way people usually sense a parallelogram. A quadrilateral A B C D is parallelogram_nd if it is ND, is a parallelogram, and satisfies non_triv. -/
def ParallelogramND.mk_parallelogramND_of_non_triv {P : Type _} [EuclideanPlane P] {prg : Parallelogram P} (non_triv: prg.non_triv): ParallelogramND P where
  toQuadrilateral := prg.toQuadrilateral
  nd := sorry
  convex := sorry
  is_parallelogram := sorry

-- `name maybe changed`
scoped notation "non_triv_PRG_nd" => ParallelogramND.mk_non_triv

/-- A quadrilateral A B C D is parallelogram_nd if it is ND, is a parallelogram, and satisfies IsPara. -/
def ParallelogramND.mk_parallelogramND_of_IsPara {P : Type _} [EuclideanPlane P] (A B C D : P) (h : (QDR A B C D).IsND) (h': (QDR A B C D) IsPrg) (IsPara: (QDR_nd A B C D h).IsPara): ParallelogramND P where
  point₁ := A; point₂ := B; point₃ := C; point₄ := D
  nd := h
  convex := sorry
  is_parallelogram := h'

-- `name maybe changed`
scoped notation "IsPara_PRG_nd" => ParallelogramND.mk_parallelogram_para

/- here is two theorem using first version of definition of PRG_nd, may not useful currently. -/
-- theorem Quadrilateral.IsParallelogram_nd_redef {P : Type _} [EuclideanPlane P] (qdr : Quadrilateral P) (h: qdr.IsND) (h': qdr IsPrg) (h': (((Quadrilateral_nd.mk_is_nd h).angle₁.value.IsPos ∧ (Quadrilateral_nd.mk_is_nd h).angle₃.value.IsPos) ∨ ((Quadrilateral_nd.mk_is_nd h).angle₁.value.IsNeg ∧ (Quadrilateral_nd.mk_is_nd h).angle₃.value.IsNeg) ∨ ((Quadrilateral_nd.mk_is_nd h).angle₂.value.IsPos ∧ (Quadrilateral_nd.mk_is_nd h).angle₄.value.IsPos) ∨ ((Quadrilateral_nd.mk_is_nd h).angle₂.value.IsNeg ∧ (Quadrilateral_nd.mk_is_nd h).angle₄.value.IsNeg))) : (Quadrilateral_nd.mk_is_nd h).IsParallelogramND := sorry

-- theorem Parallelogram.parallelogramIs_nd_redef {P : Type _} [EuclideanPlane P] (prg : Parallelogram P) (h': prg.1.IsND) (k: ((Quadrilateral_nd.mk_is_nd h').angle₁.value.IsPos ∧ (Quadrilateral_nd.mk_is_nd h').angle₃.value.IsPos) ∨ ((Quadrilateral_nd.mk_is_nd h').angle₁.value.IsNeg ∧ (Quadrilateral_nd.mk_is_nd h').angle₃.value.IsNeg) ∨ ((Quadrilateral_nd.mk_is_nd h').angle₂.value.IsPos ∧ (Quadrilateral_nd.mk_is_nd h').angle₄.value.IsPos) ∨ ((Quadrilateral_nd.mk_is_nd h').angle₂.value.IsNeg ∧ (Quadrilateral_nd.mk_is_nd h').angle₄.value.IsNeg)) : (Quadrilateral_nd.mk_is_nd h').IsParallelogramND := sorry

section perm

variable {P : Type _} [EuclideanPlane P]
variable (qdr : Quadrilateral P)
variable (qdr_nd : Quadrilateral_nd P)
variable (qdr_cvx : Quadrilateral_cvx P)
variable (prg : Parallelogram P)

/-- If a quadrilateral is a parallelogram, then its perm is also a parallelogram. -/
theorem qdr_is_parallelogram_perm_iff : (qdr.IsParallelogram) ↔ ((qdr.perm).IsParallelogram) := by
  unfold Quadrilateral.perm
  unfold Quadrilateral.IsParallelogram
  simp only
  unfold Vec.mkPtPt
  rw [eq_comm]
  refine (eq_iff_eq_of_sub_eq_sub ?H)
  rw [vsub_sub_vsub_comm]

/-- If a quadrilateral is a parallelogram_nd, then its perm is also a parallelogram_nd. -/
theorem qdr_is_parallelogramND_perm_iff : (qdr.IsParallelogramND) ↔ ((qdr.perm).IsParallelogramND) := by sorry

/-- If a quadrilateral satisfies IsPara, then its perm also satisfies IsPara. -/
theorem qdr_IsPara_perm_iff : (qdr.IsPara) ↔ ((qdr.perm).IsPara) := by sorry

/-- If a quadrilateral_nd satisfies IsPara, then its perm also satisfies IsPara. -/
theorem qdr_nd_IsPara_perm_iff : (qdr_nd.IsPara) ↔ ((qdr_nd.perm).IsPara) := by sorry

/-- If a quadrilateral satisfies IsPara, then its perm also satisfies IsPara. -/
theorem qdr_is_non_triv_perm_iff : (qdr.non_triv) ↔ ((qdr.perm).IsPara) := by sorry

end perm

section flip

variable {P : Type _} [EuclideanPlane P]
variable (qdr : Quadrilateral P)
variable (qdr_nd : Quadrilateral_nd P)
variable (qdr_cvx : Quadrilateral_cvx P)
variable (prg : Parallelogram P)

/-- If a quadrilateral is a parallelogram, then its flip is also a parallelogram. -/
theorem qdr_is_parallelogram_flip_iff : (qdr.IsParallelogram) ↔ ((qdr.flip).IsParallelogram) := by
  unfold Quadrilateral.flip
  unfold Quadrilateral.IsParallelogram
  simp only
  unfold Vec.mkPtPt
  refine (eq_iff_eq_of_sub_eq_sub ?H)
  sorry

/-- If a quadrilateral is a parallelogram_nd, then its flip is also a parallelogram_nd. -/
theorem qdr_is_parallelogramND_flip_iff : (qdr.IsParallelogramND) ↔ ((qdr.flip).IsParallelogramND) := by
  sorry

/-- If a quadrilateral satisfies IsPara, then its flip also satisfies IsPara. -/
theorem qdr_IsPara_flip_iff : (qdr.IsPara) ↔ ((qdr.flip).IsPara) := by sorry

/-- If a quadrilateral_nd satisfies IsPara, then its flip also satisfies IsPara. -/
theorem qdr_nd_IsPara_flip_iff : (qdr_nd.IsPara) ↔ ((qdr_nd.flip).IsPara) := by sorry

/-- If a quadrilateral satisfies IsPara, then its flip also satisfies IsPara. -/
theorem qdr_is_non_triv_flip_iff : (qdr.non_triv) ↔ ((qdr.flip).non_triv) := by sorry

end flip

section criteria_prg_nd_of_prg

variable {P : Type _} [EuclideanPlane P]
variable (qdr_nd : Quadrilateral_nd P)
variable (prg : Parallelogram P)

/-- If the 2nd, 3rd and 4th points of a parallelogram are not collinear, then it is a parallelogram_nd. -/
theorem isPrgND_of_Prg_not_colinear₁ (h : ¬ colinear prg.point₂ prg.point₃ prg.point₄) : prg.IsParallelogramND := by
  sorry

/-- If the 3rd, 4th and 1st points of a parallelogram are not collinear, then it is a parallelogram_nd. -/
theorem isPrgND_of_Prg_not_colinear₂ (h: ¬ colinear prg.point₃ prg.point₄ prg.point₁) : prg.IsParallelogramND := by
  sorry

/-- If the 4th, 1st and 2nd points of a parallelogram are not collinear, then it is a parallelogram_nd. -/
theorem isPrgND_of_Prg_not_colinear₃ (h: ¬ colinear prg.point₄ prg.point₁ prg.point₂) : prg.IsParallelogramND := by
  sorry

/-- If the 1st, 2nd and 3rd points of a parallelogram are not collinear, then it is a parallelogram_nd. -/
theorem isPrgND_of_Prg_not_colinear₄ (h: ¬ colinear prg.point₁ prg.point₂ prg.point₃) : prg.IsParallelogramND := by
  sorry

/- We leave these four theorems as interface for the user. They are simply replica of the theorems above. -/
theorem isPrgND_iff_not_colinear₁ : prg.IsParallelogramND ↔ (¬ colinear prg.point₂ prg.point₃ prg.point₄) := sorry

theorem isPrgND_iff_not_colinear₂ : prg.IsParallelogramND ↔ (¬ colinear prg.point₃ prg.point₄ prg.point₁) := sorry

theorem isPrgND_iff_not_colinear₃ : prg.IsParallelogramND ↔ (¬ colinear prg.point₄ prg.point₁ prg.point₂) := sorry

theorem isPrgND_iff_not_colinear₄ : prg.IsParallelogramND ↔ (¬ colinear prg.point₁ prg.point₂ prg.point₃) := sorry

end criteria_prg_nd_of_prg

/- `besides these, we also need the make method from qdr and qdr_nd to prg_nd `-/

-- `the form of all the codes above needs more discussion`

section criteria_prg_nd_of_qdr_nd

variable {P : Type _} [EuclideanPlane P]
variable {A B C D : P} (nd : (QDR A B C D).IsND)
variable (qdr : Quadrilateral P) (qdr_nd : Quadrilateral_nd P)

/-- If a quadrilateral_nd satisfies IsPara and its 1st, 2nd and 3rd points are not collinear, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_para_para_not_colinear₄ (h: qdr_nd.IsPara) (notcolinear : ¬ colinear qdr_nd.point₁ qdr_nd.point₂ qdr_nd.point₃) : qdr_nd.IsParallelogramND := by
  sorry

/-- If a quadrilateral_nd A B C D satisfies IsPara and A, B and C are not collinear, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_para_para_not_colinear₄_variant (h: (QDR_nd A B C D nd).IsPara) (notcolinear : ¬ colinear A B C) : (QDR_nd A B C D nd).IsParallelogramND := qdr_nd_is_prg_nd_of_para_para_not_colinear₄ (QDR_nd A B C D nd) h notcolinear

/-- If a quadrilateral_nd satisfies IsPara and its 2nd, 3rd and 4th points are not collinear, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_para_para_not_colinear₁ (h: qdr_nd.IsPara) (notcolinear : ¬ colinear qdr_nd.point₂ qdr_nd.point₃ qdr_nd.point₄) : qdr_nd.IsParallelogramND := by
  sorry

/-- If a quadrilateral_nd A B C D satisfies IsPara and B, C and D are not collinear, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_para_para_not_colinear₁_variant (h: (QDR_nd A B C D nd).IsPara) (notcolinear : ¬ colinear B C D) : (QDR_nd A B C D nd).IsParallelogramND := qdr_nd_is_prg_nd_of_para_para_not_colinear₁ (QDR_nd A B C D nd) h notcolinear

/-- If a quadrilateral_nd satisfies IsPara and its 3rd, 4th and 1st points are not collinear, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_para_para_not_colinear₂ (h: qdr_nd.IsPara) (notcolinear : ¬ colinear qdr_nd.point₃ qdr_nd.point₄ qdr_nd.point₁) : qdr_nd.IsParallelogramND := by
  sorry

/-- If a quadrilateral_nd A B C D satisfies IsPara and C, D and A are not collinear, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_para_para_not_colinear₂_variant (h: (QDR_nd A B C D nd).IsPara) (notcolinear : ¬ colinear C D A) : (QDR_nd A B C D nd).IsParallelogramND := qdr_nd_is_prg_nd_of_para_para_not_colinear₂ (QDR_nd A B C D nd) h notcolinear

/-- If a quadrilateral_nd satisfies IsPara and its 4th, 1st and 2nd points are not collinear, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_para_para_not_colinear₃ (h: qdr_nd.IsPara) (notcolinear : ¬ colinear qdr_nd.point₄ qdr_nd.point₁ qdr_nd.point₂) : qdr_nd.IsParallelogramND := sorry

/-- If a quadrilateral_nd A B C D satisfies IsPara and D, A and B are not collinear, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_para_para_not_colinear₃_variant (h: (QDR_nd A B C D nd).IsPara) (notcolinear : ¬ colinear D A B) : (QDR_nd A B C D nd).IsParallelogramND := qdr_nd_is_prg_nd_of_para_para_not_colinear₃ (QDR_nd A B C D nd) h notcolinear

/-- If the 1st, 3rd and 2nd, 4th angle of a quadrilateral_nd are equal in value respectively, and its 1st, 2nd and 3rd points are not collinear, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_eq_angle_value_eq_angle_value_not_colinear₄ (h₁ : qdr_nd.angle₁.value = qdr_nd.angle₃.value) (h₂ : qdr_nd.angle₂.value = qdr_nd.angle₄.value) (notcolinear : ¬ colinear qdr_nd.point₁ qdr_nd.point₂ qdr_nd.point₃) : qdr_nd.IsParallelogramND := by
  sorry

/-- If ∠ A and ∠ C, ∠ B and ∠ D are equal in value respectively, and A, B, C are not collinear, then quadrilateral_nd A B C D is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_eq_angle_value_eq_angle_value_not_colinear₄_variant (h₁ : (ANG D A B (QDR_nd A B C D nd).nd₁₄.out (QDR_nd A B C D nd).nd₁₂.out).value = (ANG B C D (QDR_nd A B C D nd).nd₂₃.out.symm (QDR_nd A B C D nd).nd₃₄.out).value) (h₂ : (ANG A B C (QDR_nd A B C D nd).nd₁₂.out.symm (QDR_nd A B C D nd).nd₂₃.out).value = (ANG C D A (QDR_nd A B C D nd).nd₃₄.out.symm (QDR_nd A B C D nd).nd₁₄.out.symm).value) (notcolinear : ¬ colinear A B C) : (QDR_nd A B C D nd).IsParallelogramND := qdr_nd_is_prg_nd_of_eq_angle_value_eq_angle_value_not_colinear₄ (QDR_nd A B C D nd) h₁ h₂ notcolinear

/-- If the 1st, 3rd and 2nd, 4th angle of a quadrilateral_nd are equal in value respectively, and its 2nd, 3rd and 4th points are not collinear, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_eq_angle_value_eq_angle_value_not_colinear₁ (h₁ : qdr_nd.angle₁.value = qdr_nd.angle₃.value) (h₂ : qdr_nd.angle₂.value = qdr_nd.angle₄.value) (notcolinear : ¬ colinear qdr_nd.point₂ qdr_nd.point₃ qdr_nd.point₄) : qdr_nd.IsParallelogramND := by sorry

/-- If ∠ A and ∠ C, ∠ B and ∠ D are equal in value respectively, and B, C, D are not collinear, then quadrilateral_nd A B C D is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_eq_angle_value_eq_angle_value_not_colinear₁_variant (h₁ : (ANG D A B (QDR_nd A B C D nd).nd₁₄.out (QDR_nd A B C D nd).nd₁₂.out).value = (ANG B C D (QDR_nd A B C D nd).nd₂₃.out.symm (QDR_nd A B C D nd).nd₃₄.out).value) (h₂ : (ANG A B C (QDR_nd A B C D nd).nd₁₂.out.symm (QDR_nd A B C D nd).nd₂₃.out).value = (ANG C D A (QDR_nd A B C D nd).nd₃₄.out.symm (QDR_nd A B C D nd).nd₁₄.out.symm).value) (notcolinear : ¬ colinear B C D) : (QDR_nd A B C D nd).IsParallelogramND := qdr_nd_is_prg_nd_of_eq_angle_value_eq_angle_value_not_colinear₁ (QDR_nd A B C D nd) h₁ h₂ notcolinear

/-- If the 1st, 3rd and 2nd, 4th angle of a quadrilateral_nd are equal in value respectively, and its 3rd, 4th and 1st points are not collinear, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_eq_angle_value_eq_angle_value_not_colinear₂ (h₁ : qdr_nd.angle₁.value = qdr_nd.angle₃.value) (h₂ : qdr_nd.angle₂.value = qdr_nd.angle₄.value) (notcolinear : ¬ colinear qdr_nd.point₃ qdr_nd.point₄ qdr_nd.point₁) : qdr_nd.IsParallelogramND := by sorry

/-- If ∠ A and ∠ C, ∠ B and ∠ D are equal in value respectively, and C, D, A are not collinear, then quadrilateral_nd A B C D is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_eq_angle_value_eq_angle_value_not_colinear₂_variant (h₁ : (ANG D A B (QDR_nd A B C D nd).nd₁₄.out (QDR_nd A B C D nd).nd₁₂.out).value = (ANG B C D (QDR_nd A B C D nd).nd₂₃.out.symm (QDR_nd A B C D nd).nd₃₄.out).value) (h₂ : (ANG A B C (QDR_nd A B C D nd).nd₁₂.out.symm (QDR_nd A B C D nd).nd₂₃.out).value = (ANG C D A (QDR_nd A B C D nd).nd₃₄.out.symm (QDR_nd A B C D nd).nd₁₄.out.symm).value) (notcolinear : ¬ colinear C D A) : (QDR_nd A B C D nd).IsParallelogramND := qdr_nd_is_prg_nd_of_eq_angle_value_eq_angle_value_not_colinear₂ (QDR_nd A B C D nd) h₁ h₂ notcolinear

/-- If the 1st, 3rd and 2nd, 4th angle of a quadrilateral_nd are equal in value respectively, and its 4th, 1st and 2nd points are not collinear, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_eq_angle_value_eq_angle_value_not_colinear₃ (h₁ : qdr_nd.angle₁.value = qdr_nd.angle₃.value) (h₂ : qdr_nd.angle₂.value = qdr_nd.angle₄.value) (notcolinear : ¬ colinear qdr_nd.point₄ qdr_nd.point₁ qdr_nd.point₂) : qdr_nd.IsParallelogramND := by sorry

/-- If ∠ A and ∠ C, ∠ B and ∠ D are equal in value respectively, and D, A, B are not collinear, then quadrilateral_nd A B C D is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_eq_angle_value_eq_angle_value_not_colinear₃_variant (h₁ : (ANG D A B (QDR_nd A B C D nd).nd₁₄.out (QDR_nd A B C D nd).nd₁₂.out).value = (ANG B C D (QDR_nd A B C D nd).nd₂₃.out.symm (QDR_nd A B C D nd).nd₃₄.out).value) (h₂ : (ANG A B C (QDR_nd A B C D nd).nd₁₂.out.symm (QDR_nd A B C D nd).nd₂₃.out).value = (ANG C D A (QDR_nd A B C D nd).nd₃₄.out.symm (QDR_nd A B C D nd).nd₁₄.out.symm).value) (notcolinear : ¬ colinear D A B) : (QDR_nd A B C D nd).IsParallelogramND := qdr_nd_is_prg_nd_of_eq_angle_value_eq_angle_value_not_colinear₃ (QDR_nd A B C D nd) h₁ h₂ notcolinear

/-- If edge_nd₁₂, edge_nd₃₄ and edge_nd₁₄, edge_nd₂₃ of a quadrilateral_nd are equal in value respectively, and angle₁ and angle₃ are of the same sign, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_eq_length_eq_length_eq_angle_sign (h₁ : qdr_nd.edge_nd₁₂.length = qdr_nd.edge_nd₃₄.length) (h₂ : qdr_nd.edge_nd₁₄.length = qdr_nd.edge_nd₂₃.length) (h : (qdr_nd.angle₁.value.IsPos ∧ qdr_nd.angle₃.value.IsPos) ∨ (qdr_nd.angle₁.value.IsNeg ∧ qdr_nd.angle₃.value.IsNeg)) : qdr_nd.IsParallelogramND := by sorry

/-- If AB = CD, AD = BC and the angles A and C of quadrilateral_nd A B C D are of the same sign, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_eq_length_eq_length_eq_angle_sign_variant (h₁ : (QDR_nd A B C D nd).edge_nd₁₂.length = (QDR_nd A B C D nd).edge_nd₃₄.length) (h₂ : (QDR_nd A B C D nd).edge_nd₁₄.length = (QDR_nd A B C D nd).edge_nd₂₃.length) (h : ((ANG D A B (QDR_nd A B C D nd).nd₁₄.out (QDR_nd A B C D nd).nd₁₂.out).value.IsPos ∧ (ANG B C D (QDR_nd A B C D nd).nd₂₃.out.symm (QDR_nd A B C D nd).nd₃₄.out).value.IsPos) ∨ ((ANG D A B (QDR_nd A B C D nd).nd₁₄.out (QDR_nd A B C D nd).nd₁₂.out).value.IsNeg ∧ (ANG B C D (QDR_nd A B C D nd).nd₂₃.out.symm (QDR_nd A B C D nd).nd₃₄.out).value.IsNeg)) : (QDR_nd A B C D nd).IsParallelogramND := qdr_nd_is_prg_nd_of_eq_length_eq_length_eq_angle_sign (QDR_nd A B C D nd) h₁ h₂ h

/-- If edge_nd₁₂, edge_nd₃₄ and edge_nd₁₄, edge_nd₂₃ of a quadrilateral_nd are equal in value respectively, and angle₂ and angle₄ are of the same sign, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_eq_length_eq_length_eq_angle_sign' (h₁ : qdr_nd.edge_nd₁₂.length = qdr_nd.edge_nd₃₄.length) (h₂ : qdr_nd.edge_nd₁₄.length = qdr_nd.edge_nd₂₃.length) (h : (qdr_nd.angle₂.value.IsPos ∧ qdr_nd.angle₄.value.IsPos) ∨ (qdr_nd.angle₂.value.IsNeg ∧ qdr_nd.angle₄.value.IsNeg)) : qdr_nd.IsParallelogramND := by sorry

/-- If AB = CD, AD = BC and the angles B and D of quadrilateral_nd A B C D are of the same sign, then it is a parallelogram_nd. -/
theorem qdr_nd_is_prg_nd_of_eq_length_eq_length_eq_angle_sign'_variant (h₁ : (QDR_nd A B C D nd).edge_nd₁₂.length = (QDR_nd A B C D nd).edge_nd₃₄.length) (h₂ : (QDR_nd A B C D nd).edge_nd₁₄.length = (QDR_nd A B C D nd).edge_nd₂₃.length) (h : ((ANG A B C (QDR_nd A B C D nd).nd₁₂.out.symm (QDR_nd A B C D nd).nd₂₃.out).value.IsPos ∧ (ANG C D A (QDR_nd A B C D nd).nd₃₄.out.symm (QDR_nd A B C D nd).nd₁₄.out.symm).value.IsPos) ∨ ((ANG A B C (QDR_nd A B C D nd).nd₁₂.out.symm (QDR_nd A B C D nd).nd₂₃.out).value.IsNeg ∧ (ANG C D A (QDR_nd A B C D nd).nd₃₄.out.symm (QDR_nd A B C D nd).nd₁₄.out.symm).value.IsNeg)) : (QDR_nd A B C D nd).IsParallelogramND := qdr_nd_is_prg_nd_of_eq_length_eq_length_eq_angle_sign' (QDR_nd A B C D nd) h₁ h₂ h

end criteria_prg_nd_of_qdr_nd

section criteria_prg_of_qdr_nd

variable {P : Type _} [EuclideanPlane P]
variable {A B C D: P}
variable (nd : (QDR A B C D).IsND)
variable (cvx : (QDR A B C D).IsConvex)
variable {P : Type _} [EuclideanPlane P] (qdr_nd : Quadrilateral_nd P)
variable {P : Type _} [EuclideanPlane P] (qdr : Quadrilateral P)

-- `why this theorem used two set of paralled and equal?`
/-- If edge_nd₁₂ and edge_nd₃₄ of a quadrilateral_nd are equal in value and parallel, and so do edge_nd₁₄ and edge_nd₂₃, then it is a parallelogram. -/
theorem qdr_nd_is_prg_of_para_eq_length_para_eq_length (h₁ : qdr_nd.edge_nd₁₂ ∥ qdr_nd.edge_nd₃₄) (h₂ : qdr_nd.edge_nd₁₂.length = qdr_nd.edge_nd₃₄.length) (H₁ : qdr_nd.edge_nd₁₄ ∥ qdr_nd.edge_nd₂₃) (H₂ : qdr_nd.edge_nd₁₄.length = qdr_nd.edge_nd₂₃.length): qdr_nd.IsParallelogram := by
  sorry

/-- If AB and CD are equal in value and parallel, and so do AD and BC, then quadrilateral_nd A B C D is a parallelogram. -/
theorem qdr_nd_is_prg_of_para_eq_length_para_eq_length_varient (h₁ : (QDR_nd A B C D nd).edge_nd₁₂ ∥ (QDR_nd A B C D nd).edge_nd₃₄) (h₂ : (QDR_nd A B C D nd).edge_nd₁₂.length = (QDR_nd A B C D nd).edge_nd₃₄.length) (H₁ : (QDR_nd A B C D nd).edge_nd₁₄ ∥ (QDR_nd A B C D nd).edge_nd₂₃) (H₂ : (QDR_nd A B C D nd).edge_nd₁₄.length = (QDR_nd A B C D nd).edge_nd₂₃.length): (Quadrilateral_nd.mk_is_nd nd).IsParallelogram := by
  sorry

/-- If the midpoint of the two diags of a quadrilateral_nd are exactly the same, then it is a parallelogram. -/
theorem qdr_nd_is_prg_nd_of_diag_inx_eq_mid_eq_mid (h' : (qdr_nd.diag₁₃).midpoint = (qdr_nd.diag₂₄).midpoint) : qdr_nd.IsParallelogram := by
  sorry

/-- If the midpoint of AC and BD are exactly the same, then quadrilateral_nd A B C D is a parallelogram. -/
theorem qdr_nd_is_prg_nd_of_diag_inx_eq_mid_eq_mid_variant (h' : (SEG A C).midpoint = (SEG B D).midpoint) : (Quadrilateral_nd.mk_is_nd nd).IsParallelogram := by
  sorry

end criteria_prg_of_qdr_nd

section criteria_prg_nd_of_qdr_cvx

variable {P : Type _} [EuclideanPlane P]
variable {A B C D : P}
variable (nd : (QDR A B C D).IsND)
variable (cvx : (QDR A B C D).IsConvex)
variable {P : Type _} [EuclideanPlane P] (qdr_cvx : Quadrilateral_cvx P)
variable {P : Type _} [EuclideanPlane P] (qdr : Quadrilateral P)

/-- If edge_nd₁₂ and edge_nd₃₄ of a quadrilateral_cvx are parallel, and so do edge_nd₁₄ and edge_nd₂₃, then it is a parallelogram_nd. -/
theorem qdr_cvx_is_prg_nd_of_para_para (h₁ : qdr_cvx.edge_nd₁₂ ∥ qdr_cvx.edge_nd₃₄) (h₂ : qdr_cvx.edge_nd₁₄ ∥ qdr_cvx.edge_nd₂₃) : qdr_cvx.IsParallelogramND := by sorry

/-- If AB and CD are parallel, and so do AD and BC, then quadrilateral_cvx A B C D is a parallelogram_nd. -/
theorem qdr_cvx_is_prg_nd_of_para_para_variant (h₁ : (QDR_cvx A B C D cvx).edge_nd₁₂ ∥ (QDR_cvx A B C D cvx).edge_nd₃₄) (h₂ : (QDR_cvx A B C D cvx).edge_nd₁₄ ∥ (QDR_cvx A B C D cvx).edge_nd₂₃) : (Quadrilateral_nd.mk_is_nd nd).IsParallelogramND := by sorry

/-- If edge_nd₁₂ and edge_nd₃₄ of a quadrilateral_cvx are equal in length, and so do edge_nd₁₄ and edge_nd₂₃, then it is a parallelogram_nd. -/
theorem qdr_cvx_is_prg_nd_of_eq_length_eq_length (h₁ : qdr_cvx.edge_nd₁₂.length = qdr_cvx.edge_nd₃₄.length) (h₂ : qdr_cvx.edge_nd₁₄.length = qdr_cvx.edge_nd₂₃.length) : qdr_cvx.IsParallelogramND := by sorry

/-- If AB and CD are equal in length, and so do AD and BC, then quadrilateral_cvx A B C D is a parallelogram_nd. -/
theorem qdr_cvx_is_prg_nd_of_eq_length_eq_length_variant (h₁ : (SEG A B).length = (SEG C D).length) (h₂ : (SEG A D).length = (SEG B C).length) : (Quadrilateral_nd.mk_is_nd nd).IsParallelogramND := by sorry

/-- If edge_nd₁₂ and edge_nd₃₄ of a quadrilateral_cvx are not only equal in length but also parallel, then it is a parallelogram_nd. -/
theorem qdr_cvx_is_prg_nd_of_para_eq_length (h₁ : qdr_cvx.edge_nd₁₂ ∥ qdr_cvx.edge_nd₃₄) (h₂ : qdr_cvx.edge_nd₁₂.length = qdr_cvx.edge_nd₃₄.length) : qdr_cvx.IsParallelogramND := by sorry

/-- If AB and CD are not only equal in length but also parallel, then quadrilateral_cvx A B C D is a parallelogram_nd. -/
theorem qdr_cvx_is_prg_nd_of_para_eq_length_variant (h₁ : (QDR_cvx A B C D cvx).edge_nd₁₂ ∥ (QDR_cvx A B C D cvx).edge_nd₃₄) (h₂ : (QDR_cvx A B C D cvx).edge_nd₁₂.length = (QDR_cvx A B C D cvx).edge_nd₃₄.length) : (Quadrilateral_nd.mk_is_nd nd).IsParallelogramND := by sorry

/-- If edge_nd₁₄ and edge_nd₂₃ of a quadrilateral_cvx are not only equal in length but also parallel, then it is a parallelogram_nd. -/
theorem qdr_cvx_is_prg_nd_of_para_eq_length' (h₁ : qdr_cvx.edge_nd₁₄ ∥ qdr_cvx.edge_nd₂₃) (h₂ : qdr_cvx.edge_nd₁₄.length = qdr_cvx.edge_nd₂₃.length) : qdr_cvx.IsParallelogramND := by sorry

/-- If AD and BC are not only equal in length but also parallel, then quadrilateral_cvx A B C D is a parallelogram_nd. -/
theorem qdr_cvx_is_prg_nd_of_para_eq_length'_variant (h₁ : (QDR_cvx A B C D cvx).edge_nd₁₄ ∥ (QDR_cvx A B C D cvx).edge_nd₂₃) (h₂ : (QDR_cvx A B C D cvx).edge_nd₁₄.length = (QDR_cvx A B C D cvx).edge_nd₂₃.length) : (Quadrilateral_nd.mk_is_nd nd).IsParallelogramND := by
  sorry

/-- If angle₁ and angle₃ of a quadrilateral_cvx are equal in value, and so do angle₂ and angle₄, then it is a parallelogram_nd. -/
theorem qdr_cvx_is_prg_nd_of_eq_angle_value_eq_angle_value (h₁ : qdr_cvx.angle₁ = qdr_cvx.angle₃) (h₂ : qdr_cvx.angle₂ = qdr_cvx.angle₄) : qdr_cvx.IsParallelogramND := by sorry

/-- If ∠ A and ∠ C are equal in value, and so do ∠ B and ∠ D, then quadrilateral_cvx A B C D is a parallelogram_nd. -/
theorem qdr_cvx_is_prg_nd_of_eq_angle_value_eq_angle_value_variant (h₁ : (QDR_cvx A B C D cvx).angle₁ = (QDR_cvx A B C D cvx).angle₃) (h₂ : (QDR_cvx A B C D cvx).angle₂ = (QDR_cvx A B C D cvx).angle₄) : (QDR_cvx A B C D cvx).IsParallelogramND := by sorry

/-- If the midpoint of the two diags of a quadrilateral_cvx are exactly the same, then it is a parallelogram_nd. -/
theorem qdr_cvx_is_prg_nd_of_diag_inx_eq_mid_eq_mid (h' : qdr_cvx.diag_nd₁₃.midpoint = qdr_cvx.diag_nd₂₄.midpoint) : qdr_cvx.IsParallelogramND := by sorry

/-- If the midpoint of AC and BD are exactly the same, then quadrilateral_cvx A B C D is a parallelogram_nd. -/
theorem qdr_cvx_is_prg_of_diag_inx_eq_mid_eq_mid_variant (h' : (SEG A C).midpoint = (SEG B D).midpoint) : (Quadrilateral_nd.mk_is_nd nd).IsParallelogramND := by
  sorry

end criteria_prg_nd_of_qdr_cvx

section property

variable {P : Type _} [EuclideanPlane P]
variable {A B C D : P}
variable {P : Type _} [EuclideanPlane P] (qdr : Quadrilateral P)
variable {P : Type _} [EuclideanPlane P] (prg : Parallelogram P)

/-- The lengths of segments point₁ point₂ and point₃ point₄ in a parallelogram are equal. -/
theorem eq_length_of_is_prg_nd : (SEG prg.point₁ prg.point₂).length = (SEG prg.point₃ prg.point₄).length := by sorry

/-- The lengths of segments A B and C D in parallelogram A B C D are equal. -/
theorem eq_length_of_is_prg_nd_variant (h : (QDR A B C D).IsParallelogram) : (SEG A B).length = (SEG C D).length := by sorry

/-- The lengths of segments point₁ point₄ and point₂ point₃ in a parallelogram are equal. -/
theorem eq_length_of_is_prg_nd' (h : qdr.IsParallelogramND) : (SEG qdr.point₁ qdr.point₄).length = (SEG qdr.point₂ qdr.point₃).length := by sorry

/-- The lengths of segments A D and B C in parallelogram A B C D are equal. -/
theorem eq_length_of_is_prg_nd'_variant  (h : (QDR A B C D).IsParallelogram) : (SEG A D).length = (SEG B C).length := by sorry

/-- The midpoints of segments point₁ point₃ and point₂ point₄ in a parallelogram are exactly the same. -/
theorem eq_midpt_of_diag_of_is_prg : (SEG prg.point₁ prg.point₃).midpoint = (SEG prg.point₂ prg.point₄).midpoint := by sorry

/-- The midpoints of segments A C and B D in parallelogram A B C D are exactly the same. -/
theorem eq_midpt_of_diag_of_is_prg_variant (h : (QDR A B C D).IsParallelogram) : (SEG A C).midpoint = (SEG B D).midpoint := by sorry

/-- Vectors point₁ point₂ and point₄ point₃ in a parallelogram are equal. -/
theorem eq_vec_of_is_prg_nd (h : qdr.IsParallelogram) : VEC qdr.point₁ qdr.point₂ = VEC qdr.point₄ qdr.point₃ := h

/-- Vectors A B and D C in parallelogram A B C D are equal. -/
theorem eq_vec_of_is_prg_nd_variant (h : (QDR A B C D).IsParallelogram) : VEC A B = VEC D C := eq_vec_of_is_prg_nd (QDR A B C D) h

/-- Vectors point₁ point₄ and point₂ point₃ in a parallelogram are equal. -/
theorem eq_vec_of_is_prg_nd' (h : qdr.IsParallelogram) : VEC qdr.point₁ qdr.point₄ = VEC qdr.point₂ qdr.point₃ := by
  rw [← vec_add_vec qdr.point₁ qdr.point₂ qdr.point₄]
  rw [← vec_add_vec qdr.point₂ qdr.point₄ qdr.point₃]
  rw [eq_vec_of_is_prg_nd qdr h]
  exact add_comm (VEC qdr.point₄ qdr.point₃) (VEC qdr.point₂ qdr.point₄)

/-- Vectors A D and B C in parallelogram A B C D are equal. -/
theorem eq_vec_of_is_prg_nd'_variant (h : (QDR A B C D).IsParallelogram) : VEC A D = VEC B C := eq_vec_of_is_prg_nd' (QDR A B C D) h

/-- In a parallelogram the sum of the square of the sides is equal to that of the two diags. -/
theorem parallelogram_law : 2 * (prg.edge₁₂).length ^ 2 + 2 * (prg.edge₂₃).length ^ 2 = (prg.diag₁₃).length ^ 2 + (prg.diag₂₄).length ^ 2 := by sorry

/-- In a parallelogram A B C D the sum of the square of the sides is equal to that of the two diags, namely 2 * AB² + 2 * BC² = AC² + BD². -/
theorem nd_parallelogram_law_variant (h : (QDR A B C D).IsParallelogram) : 2 * (SEG A B).length ^ 2 + 2 * (SEG B C).length ^ 2 = (SEG A C).length ^ 2 + (SEG B D).length ^ 2 := by sorry

end property

section property_nd

variable {P : Type _} [EuclideanPlane P]
variable {A B C D : P}
variable {P : Type _} [EuclideanPlane P] (qdr : Quadrilateral P)
variable {P : Type _} [EuclideanPlane P] (prg_nd : ParallelogramND P)

/-- Parallelogram_nd A B C D is a parallelogram. -/
theorem nd_is_prg_of_is_prg_nd_variant (A B C D : P) (h : (QDR A B C D).IsParallelogramND) : (QDR A B C D).IsParallelogram := by
  unfold Quadrilateral.IsParallelogramND at h
  rcases h with ⟨_,a⟩
  exact a

/-- Parallelogram_nd A B C D is nd. -/
theorem nd_is_nd_of_is_prg_nd_variant (h : (QDR A B C D).IsParallelogramND) : (QDR A B C D).IsND := by
  unfold Quadrilateral.IsParallelogramND at h
  rcases h with ⟨a,_⟩
  exact Quadrilateral.isND_of_is_convex a

/-- Parallelogram_nd A B C D is convex. -/
theorem nd_is_convex_of_is_prg_nd_variant (h : (QDR A B C D).IsParallelogramND) : (QDR A B C D) IsConvex := by
  unfold Quadrilateral.IsParallelogramND at h
  rcases h with ⟨a,_⟩
  exact a

/-- In a parallelogram_nd A B C D, B ≠ A. -/
theorem nd₁₂_of_is_prg_nd_variant (h : (QDR A B C D).IsParallelogramND) : B ≠ A := by
  have s : (QDR A B C D) IsConvex := by exact h.left
  exact (Quadrilateral_cvx.mk_is_convex s).nd₁₂.out

/-- In a parallelogram_nd A B C D, C ≠ B. -/
theorem nd₂₃_of_is_prg_nd_variant (h : (QDR A B C D).IsParallelogramND) : C ≠ B := by
  have s : (QDR A B C D) IsConvex := by exact h.left
  exact (Quadrilateral_cvx.mk_is_convex s).nd₂₃.out

/-- In a parallelogram_nd A B C D, D ≠ C. -/
theorem nd₃₄_of_is_prg_nd_variant (h : (QDR A B C D).IsParallelogramND) : D ≠ C := by
  have s : (QDR A B C D) IsConvex := by exact h.left
  exact (Quadrilateral_cvx.mk_is_convex s).nd₃₄.out

/-- In a parallelogram_nd A B C D, D ≠ A. -/
theorem nd₁₄_of_is_prg_nd_variant (h : (QDR A B C D).IsParallelogramND) : D ≠ A := by
  have s : (QDR A B C D) IsConvex := by exact h.left
  exact (Quadrilateral_cvx.mk_is_convex s).nd₁₄.out

/-- In a parallelogram_nd A B C D, C ≠ A. -/
theorem nd₁₃_of_is_prg_nd_variant (h : (QDR A B C D).IsParallelogramND) : C ≠ A := by
  have s : (QDR A B C D) IsConvex := by exact h.left
  exact (Quadrilateral_cvx.mk_is_convex s).nd₁₃.out

/-- In a parallelogram_nd A B C D, D ≠ B. -/
theorem nd₂₄_of_is_prg_nd_variant (h : (QDR A B C D).IsParallelogramND) : D ≠ B := by
  have s : (QDR A B C D) IsConvex := by exact h.left
  exact (Quadrilateral_cvx.mk_is_convex s).nd₂₄.out

/-- In a parallelogram_nd, edge_nd₁₂ and edge₃₄ are parallel. -/
theorem nd_para_of_is_prg_nd : prg_nd.edge_nd₁₂ ∥ prg_nd.edge_nd₃₄ := by
  have h: prg_nd.edge_nd₁₂ ∥ prg_nd.edge_nd₃₄ ∧ prg_nd.edge_nd₁₄ ∥ prg_nd.edge_nd₂₃ := by apply IsPara_of_parallelogramND
  rcases h with ⟨a,_⟩
  exact a

/-- In a parallelogram_nd A B C D, A B and C D are parallel. -/
theorem nd_para_of_is_prg_nd_variant (h : (QDR A B C D).IsParallelogramND) : (SEG_nd A B (nd₁₂_of_is_prg_nd_variant h)) ∥ (SEG_nd C D (nd₃₄_of_is_prg_nd_variant h)) := by
  have p: (QDR A B C D).IsPara := by apply IsPara_of_parallelogramND_variant h
  have H: (QDR A B C D).IsND := nd_is_nd_of_is_prg_nd_variant h
  unfold Quadrilateral.IsPara at p
  simp only [dite_true, H] at p
  unfold Quadrilateral_nd.IsPara at p
  rcases p with ⟨a,_⟩
  exact a

/-- In a parallelogram_nd, edge_nd₁₄ and edge₂₃ are parallel. -/
theorem nd_para_of_is_prg_nd' : prg_nd.edge_nd₁₄ ∥ prg_nd.edge_nd₂₃ := by
  have h: prg_nd.edge_nd₁₂ ∥ prg_nd.edge_nd₃₄ ∧ prg_nd.edge_nd₁₄ ∥ prg_nd.edge_nd₂₃ := by apply IsPara_of_parallelogramND
  rcases h with ⟨_,a⟩
  exact a

/-- In a parallelogram_nd A B C D, A D and B C are parallel. -/
theorem nd_para_of_is_prg_nd'_variant (h : (QDR A B C D).IsParallelogramND) : SEG_nd A D (nd₁₄_of_is_prg_nd_variant h) ∥ SEG_nd B C (nd₂₃_of_is_prg_nd_variant h) := by
  have p: (QDR A B C D).IsPara := by apply IsPara_of_parallelogramND_variant h
  have H: (QDR A B C D).IsND := nd_is_nd_of_is_prg_nd_variant h
  unfold Quadrilateral.IsPara at p
  simp only [dite_true, H] at p
  unfold Quadrilateral_nd.IsPara at p
  rcases p with ⟨_,a⟩
  exact a

/-- The toDirs of edge_nd₁₂ and edge_nd₃₄ of a parallelogram_nd remain reverse. -/
theorem todir_eq_of_is_prg_nd : prg_nd.edge_nd₁₂.toDir = - prg_nd.edge_nd₃₄.toDir := by sorry

/-- The toDirs of AB and CD in parallelogram_nd A B C D remain reverse. -/
theorem todir_eq_of_is_prg_nd_variant (A B C D : P) (h : (QDR A B C D).IsParallelogramND) (h1 : B ≠ A) (h2 : C ≠ D): (SEG_nd A B h1).toDir = (SEG_nd D C h2).toDir := by sorry

/-- The toDirs of edge_nd₁₄ and edge_nd₂₃ of a parallelogram_nd remain the same. -/
theorem todir_eq_of_is_prg_nd' : prg_nd.edge_nd₁₄.toDir = prg_nd.edge_nd₂₃.toDir := by sorry

/-- The toDirs of AD and BC in parallelogram_nd A B C D remain the same. -/
theorem todir_eq_of_is_prg_nd'_variant (A B C D : P) (h : (QDR A B C D).IsParallelogramND) (h1 : D ≠ A) (h2 : C ≠ B): (SEG_nd A D h1).toDir = (SEG_nd B C h2).toDir := by sorry

/-- In a parallelogram_nd, angle₂ and angle₄ are equal. -/
theorem nd_eq_angle_value_of_is_prg_nd : prg_nd.angle₂.value = prg_nd.angle₄.value := by sorry

/-- In a parallelogram_nd A B C D, ∠ B and ∠ D are equal. -/
theorem nd_eq_angle_value_of_is_prg_nd_variant (h : (QDR A B C D).IsParallelogramND) : ANG A B C ((nd₁₂_of_is_prg_nd_variant h).symm) (nd₂₃_of_is_prg_nd_variant h) = ANG C D A ((nd₃₄_of_is_prg_nd_variant h).symm) ((nd₁₄_of_is_prg_nd_variant h).symm) := by sorry

/-- In a parallelogram_nd, angle₁ and angle₃ are equal. -/
theorem nd_eq_angle_value_of_is_prg_nd' : prg_nd.angle₁.value = prg_nd.angle₃.value := by sorry

/-- In a parallelogram_nd A B C D, ∠ A and ∠ C are equal. -/
theorem nd_eq_angle_value_of_is_prg_nd'_variant (h : (QDR A B C D).IsParallelogramND) : (ANG D A B (nd₁₄_of_is_prg_nd_variant h) (nd₁₂_of_is_prg_nd_variant h)).value = (ANG B C D ((nd₂₃_of_is_prg_nd_variant h).symm) (nd₃₄_of_is_prg_nd_variant h)).value := by sorry

/-- In a parallelogram_nd the intersection of the two diags is the same as the midpoint of diag₁₃. -/
theorem nd_eq_midpt_of_diag_inx_of_is_prg_nd : prg_nd.diag_inx = prg_nd.diag_nd₁₃.midpoint := by sorry

/-- In a parallelogram_nd the intersection of the two diags is the same as the midpoint of diag₂₄. -/
theorem nd_eq_midpt_of_diag_inx_of_is_prg_nd' : prg_nd.diag_inx = prg_nd.diag_nd₂₄.midpoint := by sorry

end property_nd
