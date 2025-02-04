CREATE TABLE [dbo].[AutoViolation] (
    [AutoViolationId]             INT           NOT NULL,
    [PolicyId]                    INT           NOT NULL,
    [UnitNbr]                     INT           NOT NULL,
    [PolicyPartyRelationId]       INT           NULL,
    [PolicyNbr]                   VARCHAR (16)  NOT NULL,
    [SublineBusinessTypeCd]       CHAR (1)      NOT NULL,
    [ViolationSequenceNbr]        INT           NULL,
    [ViolationCd]                 CHAR (2)      NULL,
    [ViolationDesc]               CHAR (50)     NULL,
    [ViolationDt]                 DATE          NULL,
    [ViolationChargeCd]           CHAR (2)      NULL,
    [ViolationOrigPointCnt]       CHAR (2)      NULL,
    [ViolationPointCnt]           INT           NULL,
    [ViolationAgedPointCnt]       CHAR (2)      NULL,
    [ViolationReceiptDt]          DATE          NULL,
    [ViolationChargedOnPolicyInd] CHAR (1)      NULL,
    [ConvictionDt]                DATE          NULL,
    [DriverNbr]                   CHAR (3)      NULL,
    [MVRSVCCd]                    CHAR (10)     NULL,
    [SurchargeExemptInd]          CHAR (1)      NULL,
    [UseInPlacementInd]           CHAR (1)      NULL,
    [OperatorNm]                  VARCHAR (50)  NULL,
    [AppliedPolicyNbr]            VARCHAR (16)  NULL,
    [UpdatedTmstmp]               DATETIME2 (7) NOT NULL,
    [UserUpdatedId]               CHAR (8)      NOT NULL,
    [LastActionCd]                CHAR (1)      NOT NULL,
    [SourceSystemCd]              CHAR (2)      NOT NULL,
    CONSTRAINT [PK_AutoViolation] PRIMARY KEY CLUSTERED ([AutoViolationId] ASC) ON [POLICYCD],
    CONSTRAINT [FK_AutoViolation_AutoUnit_01] FOREIGN KEY ([PolicyId], [UnitNbr]) REFERENCES [dbo].[AutoUnit] ([PolicyId], [UnitNbr]),
    CONSTRAINT [FK_AutoViolation_Driver_01] FOREIGN KEY ([PolicyPartyRelationId], [PolicyId], [UnitNbr]) REFERENCES [dbo].[Driver] ([PolicyPartyRelationId], [PolicyId], [UnitNbr])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_AutoViolation_01]
    ON [dbo].[AutoViolation]([PolicyId] ASC, [UnitNbr] ASC)
    ON [POLICYCI];

