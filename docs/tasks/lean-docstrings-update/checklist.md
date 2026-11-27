# Lean docstring module checklist

This inventory tracks every current repository-owned `.lean` file. It began with the 155-file
task-creation baseline and appends new files as they are added. Check an item only after applying all
applicable criteria in [README.md](README.md) and recording validation for the wave that changed it.

**Progress:** 4 / 185 modules and Lean support files

## Lake package root (1)

- [ ] `ProjectKoios.lean`

## Repository root modules (6)

- [ ] `ProjectKoios/Audit.lean`
- [ ] `ProjectKoios/BandGauge.lean`
- [ ] `ProjectKoios/DensityFunctionalTheory.lean`
- [ ] `ProjectKoios/Formal.lean`
- [ ] `ProjectKoios/QuantumMechanics.lean`
- [ ] `ProjectKoios/SolidState.lean`

## `ProjectKoios/BandGauge/Alignment/` (10)

- [ ] `ProjectKoios/BandGauge/Alignment/ConjugateLinearCoordinates.lean`
- [ ] `ProjectKoios/BandGauge/Alignment/ExactGaugeConstruction.lean`
- [ ] `ProjectKoios/BandGauge/Alignment/Family.lean`
- [ ] `ProjectKoios/BandGauge/Alignment/FamilySeparation.lean`
- [ ] `ProjectKoios/BandGauge/Alignment/FiniteFrame.lean`
- [ ] `ProjectKoios/BandGauge/Alignment/FiniteMeshProcrustes.lean`
- [ ] `ProjectKoios/BandGauge/Alignment/GaugeIdentity.lean`
- [ ] `ProjectKoios/BandGauge/Alignment/PolarTransport.lean`
- [ ] `ProjectKoios/BandGauge/Alignment/PrincipalAngleBridge.lean`
- [ ] `ProjectKoios/BandGauge/Alignment/UnitaryProcrustes.lean`

## `ProjectKoios/BandGauge/Bloch/` (4)

- [ ] `ProjectKoios/BandGauge/Bloch/AlignedDifference.lean`
- [ ] `ProjectKoios/BandGauge/Bloch/AlignedDifferenceBounds.lean`
- [ ] `ProjectKoios/BandGauge/Bloch/PeriodicRankTwo.lean`
- [ ] `ProjectKoios/BandGauge/Bloch/Sewing.lean`

## `ProjectKoios/BandGauge/Certificates/` (5)

- [ ] `ProjectKoios/BandGauge/Certificates/FinitePareto.lean`
- [ ] `ProjectKoios/BandGauge/Certificates/IntervalDecision.lean`
- [ ] `ProjectKoios/BandGauge/Certificates/RankTwoSeparation.lean`
- [ ] `ProjectKoios/BandGauge/Certificates/RankTwoSeparationBox.lean`
- [ ] `ProjectKoios/BandGauge/Certificates/RankTwoSeparationEnclosure.lean`

## `ProjectKoios/BandGauge/Decision/` (9)

- [ ] `ProjectKoios/BandGauge/Decision/AlignedOperatorBudget.lean`
- [ ] `ProjectKoios/BandGauge/Decision/FiniteAlignmentAttainment.lean`
- [ ] `ProjectKoios/BandGauge/Decision/FiniteCompatibility.lean`
- [ ] `ProjectKoios/BandGauge/Decision/FiniteCutoff.lean`
- [ ] `ProjectKoios/BandGauge/Decision/FinitePareto.lean`
- [ ] `ProjectKoios/BandGauge/Decision/FourStageResidualBudgetSynthesis.lean`
- [ ] `ProjectKoios/BandGauge/Decision/FourStageResidualChannels.lean`
- [ ] `ProjectKoios/BandGauge/Decision/MandatoryChannelComposition.lean`
- [ ] `ProjectKoios/BandGauge/Decision/OperatorChannels.lean`

## `ProjectKoios/BandGauge/Foundations/` (9)

- [ ] `ProjectKoios/BandGauge/Foundations/FiniteRankAnalyticParent.lean`
- [ ] `ProjectKoios/BandGauge/Foundations/HarmonicOptimization.lean`
- [ ] `ProjectKoios/BandGauge/Foundations/HermitianEigenvaluePerturbation.lean`
- [ ] `ProjectKoios/BandGauge/Foundations/HermitianEigenvalueRmsPerturbation.lean`
- [ ] `ProjectKoios/BandGauge/Foundations/HermitianSpectralError.lean`
- [ ] `ProjectKoios/BandGauge/Foundations/RankTwoConjugation.lean`
- [ ] `ProjectKoios/BandGauge/Foundations/RankTwoPauli.lean`
- [ ] `ProjectKoios/BandGauge/Foundations/RankTwoRotation.lean`
- [ ] `ProjectKoios/BandGauge/Foundations/RankTwoSpectralPerturbation.lean`

## `ProjectKoios/BandGauge/Fourier/FiniteAbelian/` (9)

- [ ] `ProjectKoios/BandGauge/Fourier/FiniteAbelian/Convolution.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/FiniteAbelian/HermitianPairing.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/FiniteAbelian/LatticeLeastSquares.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/FiniteAbelian/LeastSquares.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/FiniteAbelian/MatrixFrobenius.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/FiniteAbelian/Parseval.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/FiniteAbelian/PowerPartition.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/FiniteAbelian/Reconstruction.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/FiniteAbelian/Transform.lean`

## `ProjectKoios/BandGauge/Fourier/Gauge/` (10)

- [ ] `ProjectKoios/BandGauge/Fourier/Gauge/CharacterLocalitySeparation.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Gauge/CyclicQuotientRadius.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Gauge/FiniteRankLocalitySeparation.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Gauge/FixedSubspaceRepresentationBridge.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Gauge/LatticeCharacterLocalitySeparation.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Gauge/PointwiseConvolution.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Gauge/PointwiseGauge.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Gauge/ProductLocalitySeparation.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Gauge/TruncationCounterexample.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Gauge/UnitaryEquivariance.lean`

## `ProjectKoios/BandGauge/Fourier/Residual/` (2)

- [ ] `ProjectKoios/BandGauge/Fourier/Residual/Channels.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Residual/RankTwoWeightedBridge.lean`

## `ProjectKoios/BandGauge/Fourier/Support/` (5)

- [ ] `ProjectKoios/BandGauge/Fourier/Support/CenteredEvenMesh.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Support/CyclicQuotientRadius.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Support/LatticeRadius.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Support/MetricShell.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Support/RadiusGrowth.lean`

## `ProjectKoios/BandGauge/Fourier/Torus/` (2)

- [ ] `ProjectKoios/BandGauge/Fourier/Torus/NormalizedCircleBessel.lean`
- [ ] `ProjectKoios/BandGauge/Fourier/Torus/NormalizedProduct.lean`

## `ProjectKoios/BandGauge/Geometry/` (2)

- [ ] `ProjectKoios/BandGauge/Geometry/AdmissibleSets.lean`
- [ ] `ProjectKoios/BandGauge/Geometry/RankTwoLoss.lean`

## `ProjectKoios/BandGauge/Hilbert/` (6)

- [ ] `ProjectKoios/BandGauge/Hilbert/AdmissibleBalls.lean`
- [ ] `ProjectKoios/BandGauge/Hilbert/FourStageResidualChannels.lean`
- [ ] `ProjectKoios/BandGauge/Hilbert/OperatorLossBridge.lean`
- [ ] `ProjectKoios/BandGauge/Hilbert/ResidualChannels.lean`
- [ ] `ProjectKoios/BandGauge/Hilbert/SpectralLossBridge.lean`
- [ ] `ProjectKoios/BandGauge/Hilbert/WeightedFrobenius.lean`

## `ProjectKoios/BandGauge/Papers/Ragasa2026A/` (6)

- [ ] `ProjectKoios/BandGauge/Papers/Ragasa2026A/CertificateBridge.lean`
- [ ] `ProjectKoios/BandGauge/Papers/Ragasa2026A/ConstructedFalsePositive.lean`
- [ ] `ProjectKoios/BandGauge/Papers/Ragasa2026A/CorrelationHarmonic.lean`
- [ ] `ProjectKoios/BandGauge/Papers/Ragasa2026A/KappaEnclosureBridge.lean`
- [ ] `ProjectKoios/BandGauge/Papers/Ragasa2026A/OptimizedLossGeometry.lean`
- [ ] `ProjectKoios/BandGauge/Papers/Ragasa2026A/RankTwoFields.lean`

## `ProjectKoios/BandGauge/Papers/` (3)

- [ ] `ProjectKoios/BandGauge/Papers/Ragasa2026A.lean`
- [ ] `ProjectKoios/BandGauge/Papers/Ragasa2026B.lean`
- [ ] `ProjectKoios/BandGauge/Papers/Ragasa2026C.lean`

## `ProjectKoios/BandGauge/` (1)

- [ ] `ProjectKoios/BandGauge/Papers.lean`

## `ProjectKoios/BandGauge/Projection/` (6)

- [ ] `ProjectKoios/BandGauge/Projection/ApproximateCompression.lean`
- [ ] `ProjectKoios/BandGauge/Projection/LaurentObstruction.lean`
- [ ] `ProjectKoios/BandGauge/Projection/MixedNormCompression.lean`
- [ ] `ProjectKoios/BandGauge/Projection/OrderedSpectralCompression.lean`
- [ ] `ProjectKoios/BandGauge/Projection/OrderedSpectralRmsCompression.lean`
- [ ] `ProjectKoios/BandGauge/Projection/SpectralProjectionRange.lean`

## `ProjectKoios/BandGauge/SpecialFunctions/` (1)

- [ ] `ProjectKoios/BandGauge/SpecialFunctions/BesselJZeroIntegral.lean`

## `ProjectKoios/Crosswalks/PhysKit/` (2)

- [ ] `ProjectKoios/Crosswalks/PhysKit/FccBainCoordinateBridge.lean`
- [ ] `ProjectKoios/Crosswalks/PhysKit/FccBainQuotientAdmission.lean`

## `ProjectKoios/DensityFunctionalTheory/Foundations/` (3)

- [ ] `ProjectKoios/DensityFunctionalTheory/Foundations/ConstrainedSearch.lean`
- [ ] `ProjectKoios/DensityFunctionalTheory/Foundations/HohenbergKohn.lean`
- [ ] `ProjectKoios/DensityFunctionalTheory/Foundations/Variational.lean`

## `ProjectKoios/DensityFunctionalTheory/KohnSham/` (6)

- [ ] `ProjectKoios/DensityFunctionalTheory/KohnSham/ContinuumDensity.lean`
- [x] `ProjectKoios/DensityFunctionalTheory/KohnSham/ContinuumSpinDensity.lean`
- [ ] `ProjectKoios/DensityFunctionalTheory/KohnSham/FiniteBasisDensity.lean`
- [ ] `ProjectKoios/DensityFunctionalTheory/KohnSham/FiniteBasisSpinDensity.lean`
- [ ] `ProjectKoios/DensityFunctionalTheory/KohnSham/FunctionalDecomposition.lean`
- [ ] `ProjectKoios/DensityFunctionalTheory/KohnSham/OccupiedOrbitals.lean`

## `ProjectKoios/DensityFunctionalTheory/PAW/` (2)

- [ ] `ProjectKoios/DensityFunctionalTheory/PAW/FiniteTransformation.lean`
- [ ] `ProjectKoios/DensityFunctionalTheory/PAW/ProjectorAugmentation.lean`

## `ProjectKoios/Formal/` (1)

- [ ] `ProjectKoios/Formal/Authority.lean`

## `ProjectKoios/QuantumMechanics/` (12)

- [ ] `ProjectKoios/QuantumMechanics/AngularMomentum.lean`
- [ ] `ProjectKoios/QuantumMechanics/Dirac.lean`
- [ ] `ProjectKoios/QuantumMechanics/Evolution.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDifference.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDimensional.lean`
- [ ] `ProjectKoios/QuantumMechanics/Fourier.lean`
- [ ] `ProjectKoios/QuantumMechanics/HarmonicOscillator.lean`
- [ ] `ProjectKoios/QuantumMechanics/Piab1d.lean`
- [ ] `ProjectKoios/QuantumMechanics/QuantumInformation.lean`
- [ ] `ProjectKoios/QuantumMechanics/RiggedHilbertSpace.lean`
- [ ] `ProjectKoios/QuantumMechanics/SpinDensity.lean`
- [ ] `ProjectKoios/QuantumMechanics/State.lean`

## `ProjectKoios/QuantumMechanics/AngularMomentum/` (2)

- [ ] `ProjectKoios/QuantumMechanics/AngularMomentum/Continuum.lean`
- [ ] `ProjectKoios/QuantumMechanics/AngularMomentum/SpinOrbit.lean`

## `ProjectKoios/QuantumMechanics/FiniteDifference/` (8)

- [ ] `ProjectKoios/QuantumMechanics/FiniteDifference/BarrierMatching1D.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDifference/CenteredDirichlet1D.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDifference/ConstantPotential1D.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDifference/DirichletMatrixMode1D.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDifference/ExponentialMode1D.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDifference/FiniteBarrier1D.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDifference/OddExtension1D.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDifference/TwistedCyclic1D.lean`

## `ProjectKoios/QuantumMechanics/FiniteDimensional/` (15)

- [ ] `ProjectKoios/QuantumMechanics/FiniteDimensional/DecompositionIdentifiability.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDimensional/ModelClassFitting.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDimensional/OrbitalExpansion.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDimensional/OrthogonalCompression.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDimensional/RankOneResolvent.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDimensional/ReductionBasis.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDimensional/SpinEmbedding.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDimensional/SpinFrameRotation.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDimensional/SpinGlobalCollinearity.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDimensional/SpinIndependentProjection.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDimensional/SpinPauliDecomposition.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDimensional/SpinPauliResidual.lean`
- [ ] `ProjectKoios/QuantumMechanics/FiniteDimensional/SpinPauliVector.lean`
- [x] `ProjectKoios/QuantumMechanics/FiniteDimensional/SpinSO3Covariance.lean`
- [x] `ProjectKoios/QuantumMechanics/FiniteDimensional/SpinorDensityMatrix.lean`

## `ProjectKoios/QuantumMechanics/Fourier/` (1)

- [ ] `ProjectKoios/QuantumMechanics/Fourier/IntegralInjectivity.lean`

## `ProjectKoios/QuantumMechanics/Evolution/` (1)

- [ ] `ProjectKoios/QuantumMechanics/Evolution/Schrodinger.lean`

## `ProjectKoios/QuantumMechanics/HarmonicOscillator/` (12)

- [ ] `ProjectKoios/QuantumMechanics/HarmonicOscillator/Continuum.lean`
- [ ] `ProjectKoios/QuantumMechanics/HarmonicOscillator/FiniteComparison.lean`
- [ ] `ProjectKoios/QuantumMechanics/HarmonicOscillator/FiniteDifference.lean`
- [ ] `ProjectKoios/QuantumMechanics/HarmonicOscillator/FiniteLadder.lean`
- [ ] `ProjectKoios/QuantumMechanics/HarmonicOscillator/FiniteResidualCertificate.lean`
- [ ] `ProjectKoios/QuantumMechanics/HarmonicOscillator/FiniteSpectralCompression.lean`
- [ ] `ProjectKoios/QuantumMechanics/HarmonicOscillator/FiniteSpectralResidual.lean`
- [ ] `ProjectKoios/QuantumMechanics/HarmonicOscillator/HermiteEigenfunction.lean`
- [ ] `ProjectKoios/QuantumMechanics/HarmonicOscillator/HilbertBasis.lean`
- [ ] `ProjectKoios/QuantumMechanics/HarmonicOscillator/QuantumSystem.lean`
- [ ] `ProjectKoios/QuantumMechanics/HarmonicOscillator/SpectralEvolution.lean`
- [ ] `ProjectKoios/QuantumMechanics/HarmonicOscillator/TruncationDistortion.lean`

## `ProjectKoios/QuantumMechanics/Measurement/` (1)

- [ ] `ProjectKoios/QuantumMechanics/Measurement/FinitePureState.lean`

## `ProjectKoios/QuantumMechanics/QuantumInformation/` (1)

- [ ] `ProjectKoios/QuantumMechanics/QuantumInformation/Finite.lean`

## `ProjectKoios/QuantumMechanics/SpinDensity/` (4)

- [ ] `ProjectKoios/QuantumMechanics/SpinDensity/Continuum.lean`
- [x] `ProjectKoios/QuantumMechanics/SpinDensity/FiniteBasis.lean`
- [ ] `ProjectKoios/QuantumMechanics/SpinDensity/HilbertBasis.lean`
- [ ] `ProjectKoios/QuantumMechanics/SpinDensity/OscillatorBasis.lean`

## `ProjectKoios/QuantumMechanics/Operator/` (4)

- [ ] `ProjectKoios/QuantumMechanics/Operator/Hydrogen.lean`
- [ ] `ProjectKoios/QuantumMechanics/Operator/Schrodinger.lean`
- [ ] `ProjectKoios/QuantumMechanics/Operator/SelfAdjoint.lean`
- [ ] `ProjectKoios/QuantumMechanics/Operator/TestDomain.lean`

## `ProjectKoios/QuantumMechanics/Piab1d/` (2)

- [ ] `ProjectKoios/QuantumMechanics/Piab1d/FiniteDifference.lean`
- [ ] `ProjectKoios/QuantumMechanics/Piab1d/Spectrum.lean`

## `ProjectKoios/SolidState/FiniteLattice/` (5)

- [ ] `ProjectKoios/SolidState/FiniteLattice/Folding.lean`
- [ ] `ProjectKoios/SolidState/FiniteLattice/GaugeLoops.lean`
- [ ] `ProjectKoios/SolidState/FiniteLattice/ProjectorBargmann.lean`
- [ ] `ProjectKoios/SolidState/FiniteLattice/QuotientAdmission.lean`
- [ ] `ProjectKoios/SolidState/FiniteLattice/RouteCommutativity.lean`

## `ProjectKoios/SolidState/` (1)

- [ ] `ProjectKoios/SolidState/FiniteLattice.lean`

## `ProjectKoios/SolidState/TightBinding/` (4)

- [ ] `ProjectKoios/SolidState/TightBinding/TetrahedralSp3.lean`
- [ ] `ProjectKoios/SolidState/TightBinding/TetrahedralSp3sStar.lean`
- [ ] `ProjectKoios/SolidState/TightBinding/TetrahedralStructureFactors.lean`
- [ ] `ProjectKoios/SolidState/TightBinding/VoglSp3sStar.lean`

## Lean support scripts (1)

- [ ] `scripts/DeclarationDependencyGraph.lean`
