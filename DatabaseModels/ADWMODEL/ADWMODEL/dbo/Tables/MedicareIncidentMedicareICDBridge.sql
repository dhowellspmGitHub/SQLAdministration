CREATE TABLE [dbo].[MedicareIncidentMedicareICDBridge] (
    [MedicareIncidentId] INT           NOT NULL,
    [MedicareICDCodeId]  INT           NOT NULL,
    [UserUpdatedId]      CHAR (8)      NOT NULL,
    [UpdatedTmstmp]      DATETIME2 (7) NOT NULL,
    [LastActionCd]       CHAR (1)      NOT NULL,
    [SourceSystemCd]     CHAR (2)      NOT NULL,
    CONSTRAINT [PK_MedicareIncidentMedicareICDBridge] PRIMARY KEY NONCLUSTERED ([MedicareIncidentId] ASC, [MedicareICDCodeId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_MedicareIncidentMedicareICDBridge_MedicareICDCode_01] FOREIGN KEY ([MedicareICDCodeId]) REFERENCES [dbo].[MedicareICDCode] ([MedicareICDCodeId]),
    CONSTRAINT [FK_MedicareIncidentMedicareICDBridge_MedicareIncident_01] FOREIGN KEY ([MedicareIncidentId]) REFERENCES [dbo].[MedicareIncident] ([MedicareIncidentId])
) ON [CLAIMSCD];

