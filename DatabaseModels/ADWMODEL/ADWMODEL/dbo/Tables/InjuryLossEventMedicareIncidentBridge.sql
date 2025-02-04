CREATE TABLE [dbo].[InjuryLossEventMedicareIncidentBridge] (
    [MedicareIncidentId] INT           NOT NULL,
    [LossEventId]        INT           NOT NULL,
    [UserUpdatedId]      CHAR (8)      NOT NULL,
    [UpdatedTmstmp]      DATETIME2 (7) NOT NULL,
    [LastActionCd]       CHAR (1)      NOT NULL,
    [SourceSystemCd]     CHAR (2)      NOT NULL,
    CONSTRAINT [PK_InjuryLossEventMedicareIncidentBridge] PRIMARY KEY NONCLUSTERED ([MedicareIncidentId] ASC, [LossEventId] ASC) ON [CLAIMSCD],
    CONSTRAINT [FK_InjuryLEMedicareIncidentBridge_InjuryLE_01] FOREIGN KEY ([LossEventId]) REFERENCES [dbo].[InjuryLossEvent] ([LossEventId]),
    CONSTRAINT [FK_InjuryLEMedicareIncidentBridge_MedicareIncident_01] FOREIGN KEY ([MedicareIncidentId]) REFERENCES [dbo].[MedicareIncident] ([MedicareIncidentId])
) ON [CLAIMSCD];

