CREATE TABLE [dbo].[InjuryDiagnosisMedicareICDCodeBridge] (
    [InjuryDiagnosisId] INT           NOT NULL,
    [MedicareICDCodeId] INT           NOT NULL,
    [UserUpdatedId]     CHAR (8)      NOT NULL,
    [UpdatedTmstmp]     DATETIME2 (7) NOT NULL,
    [LastActionCd]      CHAR (1)      NOT NULL,
    [SourceSystemCd]    CHAR (2)      NOT NULL,
    CONSTRAINT [PK_InjuryDiagnosisMedicareICDCodeBridge] PRIMARY KEY NONCLUSTERED ([InjuryDiagnosisId] ASC, [MedicareICDCodeId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_InjuryDiagnosisMedicareICDCodeBRIDGE_InjuryDiagnosis] FOREIGN KEY ([InjuryDiagnosisId]) REFERENCES [dbo].[InjuryDiagnosis] ([InjuryDiagnosisId]),
    CONSTRAINT [FK_InjuryDiagnosisMedicareICDCodeBRIDGE_MedicareICDCode] FOREIGN KEY ([MedicareICDCodeId]) REFERENCES [dbo].[MedicareICDCode] ([MedicareICDCodeId])
) ON [CLAIMSCD];

