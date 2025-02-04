CREATE TABLE [dbo].[FarmPolicySpecialRiskDetail] (
    [PolicyId]                   INT            NOT NULL,
    [FarmPolicySpecialRiskId]    INT            NOT NULL,
    [SequenceNbr]                CHAR (3)       NOT NULL,
    [LocationID]                 BIGINT         NULL,
    [PolicyNbr]                  VARCHAR (16)   NOT NULL,
    [BoatLengthRangeNbr]         VARCHAR (50)   NULL,
    [BoatHorsePowerRangeNbr]     VARCHAR (50)   NULL,
    [PropulsionDesc]             VARCHAR (50)   NULL,
    [CoveragePremiumAmt]         DECIMAL (9, 2) NULL,
    [AcresNbr]                   INT            NULL,
    [LakeOrRecreationGroundsCnt] INT            NULL,
    [GravelPitCnt]               INT            NULL,
    [CreatedTmstmp]              DATETIME       NOT NULL,
    [UserCreatedId]              CHAR (8)       NOT NULL,
    [UpdatedTmstmp]              DATETIME2 (7)  NOT NULL,
    [UserUpdatedId]              CHAR (8)       NOT NULL,
    [LastActionCd]               CHAR (1)       NOT NULL,
    [SourceSystemCd]             CHAR (2)       NOT NULL,
    CONSTRAINT [PK_FarmPolicySpecialRiskDetail] PRIMARY KEY CLUSTERED ([FarmPolicySpecialRiskId] ASC, [PolicyId] ASC, [SequenceNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmPolicySpecialRiskDetail_FarmPolicySpecialRisk_01] FOREIGN KEY ([FarmPolicySpecialRiskId], [PolicyId]) REFERENCES [dbo].[FarmPolicySpecialRisk] ([FarmPolicySpecialRiskId], [PolicyId]),
    CONSTRAINT [FK_FarmPolicySpecialRiskDetail_Location_01] FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Location] ([LocationID])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmPolicySpecialRiskDetail_01]
    ON [dbo].[FarmPolicySpecialRiskDetail]([PolicyId] ASC)
    ON [POLICYCI];

