CREATE TABLE [dbo].[LossEventInjuryDiagnosisBridge] (
    [LossEventId]       INT           NOT NULL,
    [InjuryDiagnosisId] INT           NOT NULL,
    [UserUpdatedId]     CHAR (8)      NOT NULL,
    [UpdatedTmstmp]     DATETIME2 (7) NOT NULL,
    [LastActionCd]      CHAR (1)      NOT NULL,
    [SourceSystemCd]    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_LossEventInjuryDiagnosisBridge] PRIMARY KEY NONCLUSTERED ([LossEventId] ASC, [InjuryDiagnosisId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_LossEventInjuryDiagnosisBRIDGE_InjuryDiagnosis] FOREIGN KEY ([InjuryDiagnosisId]) REFERENCES [dbo].[InjuryDiagnosis] ([InjuryDiagnosisId]),
    CONSTRAINT [FK_LossEventInjuryDiagnosisBRIDGE_LossEvent] FOREIGN KEY ([LossEventId]) REFERENCES [dbo].[LossEvent] ([LossEventId])
) ON [CLAIMSCD];

